import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:multi_user_voice_room/app/screen/participant/participant.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  UserModel? currentUser;
  
  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthService>().user;
    _initializeRoom();
  }

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
      appBar: AppBar(
        title: const Text('Voice Room'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              if (user != null) {
                await context.read<RoomService>().leaveRoom(dotenv.env['AGORA_APP_CHANNEL']!, user);
                await context.read<AuthService>().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<RoomService>(
        builder: (context, roomService, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: roomService.participants.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const ParticipantTile(
                        name: 'Bot',
                        isSpeaking: false,
                        isMuted: true,
                        isBot: true,
                      );
                    }
                    final participant = roomService.participants[index - 1];
                    return ParticipantTile(
                      name: participant.username,
                      isSpeaking: participant.isSpeaking,
                      isMuted: participant.isMuted,
                      isBot: false,
                    );
                  },
                ),
              ),
              if (user != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<RoomService>(
                    builder: (context, roomService, _) {
                      final participant = roomService.participants.firstWhere(
                          (p) => p.uid == currentUser?.uid,
                          orElse: () => currentUser!);
                      return ElevatedButton.icon(
                        onPressed: () async {
                          if (currentUser != null) {
                            currentUser = await context
                                .read<RoomService>()
                                .toggleMute(participant);
                          }
                        },
                        icon: Icon(
                            participant.isMuted ? Icons.mic_off : Icons.mic),
                        label: Text(participant.isMuted ? 'Unmute' : 'Mute'),
                      );
                    },
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    context.read<RoomService>().dispose();
    super.dispose();
  }
}
