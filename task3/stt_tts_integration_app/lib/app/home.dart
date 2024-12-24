import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stt_tts_integration_app/app/screens/speech_to_text_screen.dart';
import 'package:stt_tts_integration_app/app/screens/text_to_speech_screen.dart';
import 'package:stt_tts_integration_app/app/utils/utils.dart';
import 'package:stt_tts_integration_app/app/widgets/card_item.dart';
import 'package:stt_tts_integration_app/app/widgets/custom_text.dart';

/// The main page of the application.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// Initializes required services, such as checking microphone permissions.
  Future<void> _initializeServices() async {
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

  /// Builds the UI for the home page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CustomText(
                text: 'Speech-to-Text and Text-to-Speech Integration',
                txtColor: Colors.white,
                fntweight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              //Speech to text
              CardItem(
                title: 'Speech to Text',
                desc: 'Tap to record,view transcribed text.',
                imageUrl: Platform.isIOS
                    ? '/Users/jeff/FlutterProjects/flutter_developer_test_assignment/task3/stt_tts_integration_app/assets/pngs/stt.png'
                    : 'assets/pngs/stt.png',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SpeechToTextScreen())),
              ),
              const SizedBox(height: 20),
              // Text-to-Speech Section
              CardItem(
                title: 'Text to Speech',
                desc: 'Convert the entered text to speech.',
                imageUrl: Platform.isIOS
                    ? '/Users/jeff/FlutterProjects/flutter_developer_test_assignment/task3/stt_tts_integration_app/assets/pngs/tts.png'
                    : 'assets/pngs/tts.png',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TextToSpeechScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
