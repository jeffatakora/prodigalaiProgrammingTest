import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:permission_handler/permission_handler.dart';

/// Manages room-related operations including participant management and Agora setup.
class RoomService with ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance for database operations.
  RtcEngine? _engine; // Agora RTC engine instance.
  List<UserModel> _participants = []; // List of participants in the room.
  String? _currentRoomId; // ID of the current room.
  final expirationInSeconds = 3600; // Token expiration time in seconds.
  final currentTimestamp =
      DateTime.now().millisecondsSinceEpoch ~/ 1000; // Current timestamp.

  /// Getter for the list of participants in the room.
  List<UserModel> get participants => _participants;

  /// Initializes the Agora RTC engine and sets up event handlers.
  Future<void> initializeAgora() async {
    // Request permissions
    await [Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: dotenv.env['AGORA_APP_ID']!,
    ));

    await _engine!.enableAudio();
    await _engine!
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableLocalAudio(true);
    await _engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioChatroom,
    );
    _setupAgoraEventHandlers();
  }

  /// Sets up Agora RTC event handlers to handle user interactions.
  void _setupAgoraEventHandlers() {
    _engine?.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        print("Local user joined");
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        print("Remote user joined: $remoteUid");
      },
      onUserOffline: (connection, remoteUid, reason) {
        print("Remote user left: $remoteUid");
      },
      onAudioVolumeIndication:
          (connection, speakers, speakerNumber, totalVolume) {
        for (var speaker in speakers) {
          _updateUserSpeaking(speaker.uid!, speaker.volume! > 50);
        }
      },
    ));
  }

  /// Updates the speaking status of a user in the room.
  Future<void> _updateUserSpeaking(int agoraId, bool isSpeaking) async {
    final participant = _participants.firstWhere(
      (p) => p.agoraId == agoraId,
      orElse: () => throw Exception('User not found'),
    );
    await updateUserSpeakingStatus(participant.uid, isSpeaking);
  }

  /// Listens for changes in room participants from Firestore.
  void _listenToParticipants(String roomId) {
    _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .snapshots()
        .listen((snapshot) {
      _participants =
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      notifyListeners();
    });
  }

  /// Joins a room and updates the participant list in Firestore.
  Future<void> joinRoom(String roomId, UserModel user) async {
    _currentRoomId = roomId;
    final expireTimestamp = currentTimestamp + expirationInSeconds;
    final token = RtcTokenBuilder.build(
      appId: dotenv.env['AGORA_APP_ID']!,
      appCertificate: dotenv.env['AGORA_APP_CERT']!,
      channelName: roomId,
      uid: user.agoraId.toString(),
      role: RtcRole.publisher,
      expireTimestamp: expireTimestamp,
    );
    await _engine?.joinChannel(
      token: token,
      channelId: roomId,
      uid: user.agoraId,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        autoSubscribeAudio: true,
      ),
    );

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .doc(user.uid)
        .set(user.toMap());

    await _updateUserStatus(user.uid, {'lastJoinedRoom': roomId});
    _listenToParticipants(roomId);
  }

  /// Updates a user's speaking status in Firestore.
  Future<void> updateUserSpeakingStatus(String userId, bool isSpeaking) async {
    await _firestore
        .collection('rooms')
        .doc(_currentRoomId)
        .collection('participants')
        .doc(userId)
        .update({'isSpeaking': isSpeaking});
  }

  /// Toggles the mute status of a user and updates Firestore and the local state.
  Future<void> toggleMute(UserModel user) async {
    final isMuted = !user.isMuted;
    await _engine?.muteLocalAudioStream(isMuted);

    user.isMuted = isMuted;

    // Update Firestore
    await _firestore
        .collection('rooms')
        .doc(_currentRoomId)
        .collection('participants')
        .doc(user.uid)
        .update({'isMuted': isMuted});

    // Force UI update
    final updatedParticipants = _participants.map((p) {
      if (p.uid == user.uid) {
        p.isMuted = isMuted;
      }
      return p;
    }).toList();

    _participants = updatedParticipants;
    notifyListeners();
  }

  /// Leaves the room and updates the user's room status in Firestore.
  Future<void> leaveRoom(String roomId, UserModel user) async {
    await _engine?.leaveChannel();
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .doc(user.uid)
        .delete();

    await _updateUserStatus(user.uid, {'lastJoinedRoom': null});
  }

  /// Updates the user's status in Firestore with given data.
  Future<void> _updateUserStatus(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
