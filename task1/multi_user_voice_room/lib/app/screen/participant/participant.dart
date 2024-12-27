import 'package:flutter/material.dart';

class ParticipantTile extends StatelessWidget {
  final String name;
  final bool isSpeaking;
  final bool isMuted;
  final bool isBot;

  const ParticipantTile({super.key, 
    required this.name,
    required this.isSpeaking,
    required this.isMuted,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isBot ? Icons.smart_toy : Icons.person,
        color: isSpeaking ? Colors.green : Colors.grey,
      ),
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSpeaking) const Icon(Icons.volume_up, color: Colors.green),
          if (isMuted) const Icon(Icons.mic_off, color: Colors.red),
        ],
      ),
    );
  }
}
