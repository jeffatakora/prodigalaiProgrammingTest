import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:multi_user_voice_room/app/screen/participant/participant.dart';
import 'package:provider/provider.dart';

/// Represents the main screen where the user joins or creates rooms.
class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  void initState() {
    super.initState();
    _initializeRoom();
  }

// Initialize Agora on screen load.
  Future<void> _initializeRoom() async {
    final roomService = context.read<RoomService>();
    final user = context.read<AuthService>().user;
    if (user != null) {
      await roomService.initializeAgora();
      await roomService.joinRoom(dotenv.env['AGORA_APP_CHANNEL']!, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<RoomService>(
          builder: (context, roomService, _) {
            final allParticipants = [
              UserModel(
                uid: 'bot',
                username: 'Bot Moderator',
                agoraId: 0,
                isMuted: true,
                isSpeaking: false,
              ),
              ...roomService.participants,
            ];

            return Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Voice Room',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: () async {
                          if (user != null) {
                            await roomService.leaveRoom(
                                dotenv.env['AGORA_APP_CHANNEL']!, user);
                            await context.read<AuthService>().signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Participants Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: allParticipants.length,
                    itemBuilder: (context, index) {
                      final participant = allParticipants[index];
                      return ParticipantCard(
                        participant: participant,
                        isCurrentUser: user?.uid == participant.uid,
                      );
                    },
                  ),
                ),

                // Bottom Controls
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (user != null)
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              user.isMuted ? Colors.red : Colors.white,
                          child: IconButton(
                            icon: Icon(
                              user.isMuted ? Icons.mic_off : Icons.mic,
                              color: user.isMuted ? Colors.white : Colors.black,
                            ),
                            onPressed: () =>
                                context.read<RoomService>().toggleMute(user),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read<RoomService>().dispose();
    super.dispose();
  }
}
