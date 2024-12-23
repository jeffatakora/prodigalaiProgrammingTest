class Cake {
  final String id;
  final String type;
  final String title;
  final String content;
  final String? task;
  final bool? userInput;
  final String? audioUrl;
  final bool? requiresRecording;
  final String? imageUrl;

  Cake({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.task,
    this.userInput,
    this.audioUrl,
    this.requiresRecording,
    this.imageUrl,
  });

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      task: json['task'],
      userInput: json['userInput'],
      audioUrl: json['audioUrl'],
      requiresRecording: json['requiresRecording'],
      imageUrl: json['imageUrl'],
    );
  }
}
