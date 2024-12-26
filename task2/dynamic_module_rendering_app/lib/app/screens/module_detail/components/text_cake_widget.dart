import 'package:dynamic_module_rendering_app/app/model/cake.dart';
import 'package:flutter/material.dart';

/// A widget that displays textual content along with an optional task and user input field.
///
/// Displays the `title`, `content`, and optionally `task` of a `Cake` object.
/// If `userInput` is true, a text field is provided for user input.
class TextCakeWidget extends StatelessWidget {
  final Cake cake;

  /// Constructs a `TextCakeWidget` with the given `Cake` object.
  const TextCakeWidget({super.key, required this.cake});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displays the title of the cake using the large title text style.
            Text(
              cake.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(cake.content),
            // Optionally displays a task if provided in the cake object.
            if (cake.task != null) ...[
              const SizedBox(height: 16),
              Text(
                'Task:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              // Displays the main content of the cake.
              Text(cake.task!),
            ],
            // Displays a text input field if `userInput` is true.
            if (cake.userInput == true) ...[
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your answer',
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
