import 'package:dynamic_module_rendering_app/app/model/cake.dart';
import 'package:flutter/material.dart';

class TextCakeWidget extends StatelessWidget {
  final Cake cake;

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
            Text(
              cake.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(cake.content),
            if (cake.task != null) ...[
              const SizedBox(height: 16),
              Text(
                'Task:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(cake.task!),
            ],
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
