import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/service/agora_service.dart';
import 'package:multi_user_voice_room/app/service/auth_services.dart';

class RoomProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String roomId;
  AgoraService? _voiceService;
  List<UserModel> _participants = [];
  bool _isInitialized = false;

  // Bot user model
  final UserModel _botUser = UserModel(
    uid: 'bot-moderator-001',
    username: 'Bot',
    agoraId: generateAgoraId('bot-moderator-001'),
    isMuted: true,
    isSpeaking: false,
  );

  RoomProvider(this.roomId) {
    _initializeRoom();
  }

  List<UserModel> get participants => _participants;
  bool get isInitialized => _isInitialized;
  UserModel get botUser => _botUser;

  Future<void> _initializeRoom() async {
    try {
      // Initialize voice service
      _voiceService = AgoraService(
        onUserSpeaking: _handleUserSpeaking,
      );
      await _voiceService!.initialize();

      // Ensure bot exists in the room
      await _ensureBotInRoom();

      // Listen to participants collection
      _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .snapshots()
          .listen((snapshot) {
        // Get all participants except bot
        final List<UserModel> regularParticipants = snapshot.docs
            .where((doc) => doc.id != _botUser.uid)
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList();

        // Always add bot to the participants list
        _participants = [_botUser, ...regularParticipants];
        notifyListeners();
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing room: $e');
      rethrow;
    }
  }

  Future<void> _ensureBotInRoom() async {
    try {
      final botRef = _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(_botUser.uid);

      final botDoc = await botRef.get();

      if (!botDoc.exists) {
        await botRef.set(_botUser.toMap());
      }
    } catch (e) {
      print('Error ensuring bot in room: $e');
    }
  }

  Future<void> joinRoom(UserModel user) async {
    try {
      // Add user to Firestore
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(user.uid)
          .set(user.toMap());

      await _voiceService?.joinChannel(roomId, user.agoraId);
    } catch (e) {
      print('Error joining room: $e');
      rethrow;
    }
  }

  Future<void> leaveRoom(String uid) async {
    try {
      // Don't allow removing the bot
      if (uid == _botUser.uid) return;

      // Remove user from Firestore
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(uid)
          .delete();

      // Leave voice channel
      await _voiceService?.leaveChannel();
    } catch (e) {
      print('Error leaving room: $e');
      rethrow;
    }
  }

  Future<void> toggleMute(String uid) async {
    try {
      // Don't allow toggling bot's mute state
      if (uid == _botUser.uid) return;

      await _voiceService?.toggleMute();
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(uid)
          .update({'isMuted': _voiceService?.isMuted});
    } catch (e) {
      print('Error toggling mute: $e');
      rethrow;
    }
  }

  void _handleUserSpeaking(int agoraID, bool isSpeaking) {
    try {
      // Add debug logging
      print(
          'Handling speaking event - AgoraID: $agoraID, Speaking: $isSpeaking');
      print(
          'Current participants: ${_participants.map((p) => '${p.username}: ${p.agoraId}').join(', ')}');

      final user = _participants.firstWhere(
        (user) => user.agoraId == agoraID, // Remove unnecessary parentheses
        orElse: () {
          print('No user found with agoraId: $agoraID');
          return throw Exception('User not found');
        },
      );

      // Don't update bot's speaking state
      if (user.uid == _botUser.uid) return;

      _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(user.uid)
          .update({'isSpeaking': isSpeaking});
    } catch (e) {
      print('Error handling user speaking: $e');
    }
  }

  @override
  void dispose() {
    _voiceService?.dispose();
    super.dispose();
  }
}
