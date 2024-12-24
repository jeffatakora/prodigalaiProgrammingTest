import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:provider/provider.dart';

class VoiceRoomScreen extends StatelessWidget {
  final UserModel currentUser;

  const VoiceRoomScreen({super.key, required this.currentUser});

  void _handleRoomExit(BuildContext context) async {
    final authProvider = context.read<AuthenticationProvider>();
    final roomProvider = context.read<RoomProvider>();

    // Leave the room first
    await roomProvider.leaveRoom(currentUser.uid);

    // Sign out the user
    await authProvider.logout();

    // Navigate to login screen and remove all previous routes
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<LoginScreen>(
          builder: (context) => const LoginScreen(),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the AuthProvider instance
    return ChangeNotifierProvider(
      create: (_) =>
          RoomProvider(dotenv.env['AGORA_APP_CHANNEL']!)..joinRoom(currentUser),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voice Room'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _handleRoomExit(context),
            ),
          ],
        ),
        body: Consumer<RoomProvider>(
          builder: (context, provider, child) {
            if (!provider.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.participants.length,
                    itemBuilder: (context, index) {
                      final participant = provider.participants[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: participant.isSpeaking
                              ? Colors.green
                              : Colors.blue,
                          child: Text(participant.username[0]),
                        ),
                        title: Text(participant.username),
                        trailing: participant.uid == currentUser.uid
                            ? IconButton(
                                icon: Icon(participant.isMuted
                                    ? Icons.mic_off
                                    : Icons.mic),
                                onPressed: () =>
                                    provider.toggleMute(currentUser.uid),
                              )
                            : Icon(participant.isMuted
                                ? Icons.mic_off
                                : Icons.mic),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Bot is monitoring the conversation',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
