import 'cake.dart';

/// Represents a module containing a collection of cakes (learning units).
class Module {
  final String id; // Unique identifier for the module.
  final String title; // The title of the module.
  final String description; // A brief description of the module.
  final String imageUrl; // URL of the image representing the module.
  final List<Cake> cakes; // A list of cakes (learning units) within the module.

  /// Constructor to initialize the Module object.
  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cakes,
  });
 
  /// Factory method to create a Module instance from JSON data.
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      cakes:
          (json['cakes'] as List).map((cake) => Cake.fromJson(cake)).toList(),
    );
  }
}
