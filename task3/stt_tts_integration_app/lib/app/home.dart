import 'package:flutter/material.dart';
import 'package:stt_tts_integration_app/app/screens/speech_to_text_screen.dart';
import 'package:stt_tts_integration_app/app/screens/text_to_speech_screen.dart';
import 'package:stt_tts_integration_app/app/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
             const Text(
                'Speech-to-Text and Text-to-Speech Integration',
                style: TextStyle(
                  color: Colors.white,
                  // fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // speech to text Section
              Card(
                elevation: 4,
                color: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SpeechToTextScreen())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8.0)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            '/Users/jeff/FlutterProjects/flutter_developer_test_assignment/task3/stt_tts_integration_app/assets/pngs/stt.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Speech to Text',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to record,view transcribed text.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[300],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Text-to-Speech Section
              Card(
                elevation: 4,
                color: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TextToSpeechScreen())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8.0)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            '/Users/jeff/FlutterProjects/flutter_developer_test_assignment/task3/stt_tts_integration_app/assets/pngs/tts.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Text to Speech',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Convert the entered text to speech.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[300],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO END

