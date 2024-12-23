class User {
  final String id;
  final String username;
  bool isMuted;
  bool isSpeaking;

  User({
    required this.id,
    required this.username,
    this.isMuted = false,
    this.isSpeaking = false,
  });
}
