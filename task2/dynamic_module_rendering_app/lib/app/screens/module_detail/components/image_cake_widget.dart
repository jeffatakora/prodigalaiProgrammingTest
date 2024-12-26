import 'package:dynamic_module_rendering_app/app/model/cake.dart';
import 'package:flutter/material.dart';

/// A widget that displays an image cake with a title, content, and an optional task description.
class ImageCakeWidget extends StatelessWidget {
  final Cake cake;

  const ImageCakeWidget({super.key, required this.cake});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Displays the title of the cake.
            Text(
              cake.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
             /// Displays the content of the cake.
            Text(cake.content),
            const SizedBox(height: 16),
            /// Displays the image associated with the cake.
            if (cake.imageUrl != null)
              Image.asset(
                cake.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              /// Optionally displays a task description if provided.
            if (cake.task != null) ...[
              const SizedBox(height: 16),
              Text(
                'Task:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(cake.task!),
            ],
          ],
        ),
      ),
    );
  }
}
