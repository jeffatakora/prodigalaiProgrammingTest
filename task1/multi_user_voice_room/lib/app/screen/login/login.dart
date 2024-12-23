import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/provider/auth_provioder.dart';
import 'package:multi_user_voice_room/app/screen/voice_room/voice_room.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  void _handleLogin() {
    if (_usernameController.text.isNotEmpty) {
      context.read<AuthProvider>().login(_usernameController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VoiceRoomScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Voice Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
