import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/provider/auth_provioder.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/participant/participant.dart';
import 'package:multi_user_voice_room/app/service/agora_service.dart';
import 'package:provider/provider.dart';

class VoiceRoomScreen extends StatefulWidget {
  const VoiceRoomScreen({super.key});

  @override
  VoiceRoomScreenState createState() => VoiceRoomScreenState();
}

class VoiceRoomScreenState extends State<VoiceRoomScreen> {
  final _agoraService = AgoraService();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeRoom();
  }

  Future<void> _initializeRoom() async {
    final user = context.read<AuthProvider>().currentUser!;
    context.read<RoomProvider>().addParticipant(user);

    await _agoraService.initialize();
    await _agoraService.joinChannel();
  }

  void _handleMuteToggle() {
    setState(() => _isMuted = !_isMuted);
    _agoraService.toggleMute(_isMuted);

    final user = context.read<AuthProvider>().currentUser!;
    context.read<RoomProvider>().updateParticipantStatus(
          user.id,
          isMuted: _isMuted,
        );
  }

  void _handleLeaveRoom() {
    _agoraService.leaveChannel();
    final user = context.read<AuthProvider>().currentUser!;
    context.read<RoomProvider>().removeParticipant(user.id);
    context.read<AuthProvider>().logout();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _handleLeaveRoom,
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ParticipantList(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _handleMuteToggle,
                  child: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
