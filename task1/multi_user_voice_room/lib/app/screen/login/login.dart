import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/screen/voice_room/voice_room.dart';
import 'package:multi_user_voice_room/app/utils/utils.dart';
import 'package:provider/provider.dart';

/// Represents the login screen for user authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      // Get the AuthProvider instance
      final authProvider = context.read<AuthService>();

      final success = await authProvider.signInWithUsername(
        _usernameController.text.trim(),
      );
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoomScreen()),
        );
      }

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign in. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    initializeServices();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> initializeServices() async {
    // Initialize STT with permissions
    bool permissionGranted = await Utils.requestMicrophonePermission();
    if (!permissionGranted) {
      Utils.showErrorDialog(
          // ignore: use_build_context_synchronously
          context,
          'Permission Denied',
          'Microphone permission is required.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthService>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo or Icon
                  const Icon(
                    Icons.voice_chat,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Join Voice Room',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Username Input
                  TextFormField(
                    controller: _usernameController,
                    enabled: !authProvider.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Enter Room',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),

                  // Bot Info
                  const SizedBox(height: 24),
                  const Text(
                    'A bot will be present in the room',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
