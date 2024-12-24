import 'package:dynamic_module_rendering_app/app/model/cake.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/audio_player_widget.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/audio_recording_widget.dart';
import 'package:flutter/material.dart';

class AudioCakeWidget extends StatelessWidget {
  final Cake cake;

  const AudioCakeWidget({super.key, required this.cake});

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
            const SizedBox(height: 16),
            AudioPlayerWidget(audioUrl: cake.audioUrl!),
            if (cake.requiresRecording==true) ...[
              const SizedBox(height: 16),
              const AudioRecorderWidget(),
            ],
          ],
        ),
      ),
    );
  }
}
