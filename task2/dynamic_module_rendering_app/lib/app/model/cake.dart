/// Represents a single learning unit with various properties like text, audio, or image.
class Cake {
  final String id; // Unique identifier for the cake.
  final String type; // The type of the cake (e.g., 'text', 'audio', 'image').
  final String title; // The title or name of the cake.
  final String content; // The main content or description of the cake.
  final String? task; // An optional task associated with the cake.
  final bool? userInput; // Specifies if user input is required.
  final String? audioUrl; // URL of the audio file, if applicable.
  final bool?
      requiresRecording; // Indicates if the user needs to record something.
  final String? imageUrl; // URL of the image, if applicable.

  /// Constructor to initialize the Cake object.
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

  /// Factory method to create a Cake instance from JSON data.
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
