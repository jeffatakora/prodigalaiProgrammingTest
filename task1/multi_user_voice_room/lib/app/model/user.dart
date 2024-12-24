class UserModel {
  final String uid;
  final String username;
  final int agoraId;
  bool isMuted;
  bool isSpeaking;

  UserModel({
    required this.uid,
    required this.username,
    required this.agoraId,
    this.isMuted = false,
    this.isSpeaking = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'agoraId': agoraId,
      'isMuted': isMuted,
      'isSpeaking': isSpeaking,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      agoraId: map['agoraId'],
      isMuted: map['isMuted'] ?? false,
      isSpeaking: map['isSpeaking'] ?? false,
    );
  }
}
