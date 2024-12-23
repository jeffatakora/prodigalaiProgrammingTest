import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/model/user.dart';

class RoomProvider with ChangeNotifier {
  final List<User> _participants = [
    User(id: 'bot', username: 'Moderator Bot', isMuted: true),
  ];

  List<User> get participants => [..._participants];

  void addParticipant(User user) {
    if (!_participants.any((p) => p.id == user.id)) {
      _participants.add(user);
      notifyListeners();
    }
  }

  void removeParticipant(String userId) {
    _participants.removeWhere((p) => p.id == userId);
    notifyListeners();
  }

  void updateParticipantStatus(String userId,
      {bool? isMuted, bool? isSpeaking}) {
    final userIndex = _participants.indexWhere((p) => p.id == userId);
    if (userIndex != -1) {
      if (isMuted != null) _participants[userIndex].isMuted = isMuted;
      if (isSpeaking != null) _participants[userIndex].isSpeaking = isSpeaking;
      notifyListeners();
    }
  }
}
