import 'cake.dart';

class Module {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Cake> cakes;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cakes,
  });

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
