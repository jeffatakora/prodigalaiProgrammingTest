import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:permission_handler/permission_handler.dart';

class RoomService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RtcEngine? _engine;
  List<UserModel> _participants = [];
  String? _currentRoomId;
  final expirationInSeconds = 3600;
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  List<UserModel> get participants => _participants;

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

  Future<void> _updateUserSpeaking(int agoraId, bool isSpeaking) async {
    final participant = _participants.firstWhere(
      (p) => p.agoraId == agoraId,
      orElse: () => throw Exception('User not found'),
    );
    await updateUserSpeakingStatus(participant.uid, isSpeaking);
  }

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

  Future<void> updateUserSpeakingStatus(String userId, bool isSpeaking) async {
    await _firestore
        .collection('rooms')
        .doc(_currentRoomId)
        .collection('participants')
        .doc(userId)
        .update({'isSpeaking': isSpeaking});
  }

Future<UserModel> toggleMute(UserModel user) async {
    final isMuted = !user.isMuted;
    await _engine?.muteLocalAudioStream(isMuted);
    
    // Update Firestore
    await _firestore.collection('rooms')
      .doc(_currentRoomId)
      .collection('participants')
      .doc(user.uid)
      .update({'isMuted': isMuted});

    // Update local user state
    final updatedUser = UserModel(
      uid: user.uid,
      username: user.username,
      agoraId: user.agoraId,
      isMuted: isMuted,
      isSpeaking: user.isSpeaking,
    );

    // Update participants list
    final index = _participants.indexWhere((p) => p.uid == user.uid);
    if (index != -1) {
      _participants[index] = updatedUser;
      notifyListeners();
    }

    return updatedUser;
  }


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

  Future<void> _updateUserStatus(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }


}
