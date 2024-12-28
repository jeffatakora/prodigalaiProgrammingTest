import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/model/user.dart';

/// Represents a single participant in the room with a display card.
class ParticipantCard extends StatelessWidget {
  final UserModel participant;//current user model
  final bool isCurrentUser;// bool to check if user is current

  const ParticipantCard({super.key, 
    required this.participant,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Video Placeholder
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                participant.username[0].toUpperCase(),
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),

          // Username and Status
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${participant.username}${isCurrentUser ? ' (You)' : ''}',
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (participant.isSpeaking)
                        const Icon(Icons.volume_up,
                            color: Colors.green, size: 16),
                      if (participant.isMuted)
                        const Icon(Icons.mic_off, color: Colors.red, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bot Icon
          if (participant.uid == 'bot')
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.smart_toy, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
