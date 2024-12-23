import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:provider/provider.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: roomProvider.participants.length,
          itemBuilder: (context, index) {
            final participant = roomProvider.participants[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(participant.username[0]),
                ),
                title: Text(participant.username),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (participant.isSpeaking)
                      const Icon(Icons.volume_up, color: Colors.green),
                    if (participant.isMuted)
                      const Icon(Icons.mic_off, color: Colors.red),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
