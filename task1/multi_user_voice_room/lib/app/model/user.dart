/// Represents a user in the application with associated details.
class UserModel {
  final String uid; // Unique identifier for the user.
  final String username; // Username chosen by the user.
  final int agoraId; // Agora-specific user identifier.
  bool isMuted; // Indicates if the user is currently muted.
  bool isSpeaking; // Indicates if the user is currently speaking.

  /// Constructor to initialize a UserModel instance.
  UserModel({
    required this.uid,
    required this.username,
    required this.agoraId,
    this.isMuted = false,
    this.isSpeaking = false,
  });

  /// Creates a copy of the UserModel with overridden properties.
  UserModel copyWith({
    String? uid,
    String? username,
    int? agoraId,
    bool? isMuted,
    bool? isSpeaking,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      agoraId: agoraId ?? this.agoraId,
      isMuted: isMuted ?? this.isMuted,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }

  /// Converts the UserModel instance to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'agoraId': agoraId,
      'isMuted': isMuted,
      'isSpeaking': isSpeaking,
    };
  }

  /// Factory constructor to create a UserModel instance from a map.
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
