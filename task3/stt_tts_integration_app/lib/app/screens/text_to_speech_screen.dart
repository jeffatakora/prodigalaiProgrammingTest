import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:stt_tts_integration_app/app/utils/utils.dart';
import 'package:stt_tts_integration_app/app/widgets/circular_button.dart';
import 'package:stt_tts_integration_app/app/widgets/slide_control.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  double _speed = 0.5;
  double _pitch = 0.5;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(_speed);
    await flutterTts.setPitch(_pitch);
    await flutterTts.setVolume(_volume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Text to Speech',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter your text:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type something...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularButton(
                          icon: Icons.delete_outline,
                          color: Colors.pink,
                          onPressed: () {
                            _textController.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SliderControl(
                      label: 'Speed',
                      value: _speed,
                      onChanged: (value) {
                        setState(() {
                          _speed = value;
                          flutterTts.setSpeechRate(value);
                        });
                      },
                      activeColor: Colors.amber,
                    ),
                    SliderControl(
                      label: 'Pitch',
                      value: _pitch,
                      onChanged: (value) {
                        setState(() {
                          _pitch = value;
                          flutterTts.setPitch(value);
                        });
                      },
                      activeColor: Colors.pink,
                    ),
                    SliderControl(
                      label: 'Volume',
                      value: _volume,
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                          flutterTts.setVolume(value);
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_textController.text.isEmpty) {
                      Utils.showErrorDialog(context, 'Error',
                          'Please enter a text in the field.');
                    } else {
                      await flutterTts.speak(_textController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    flutterTts.stop();
    super.dispose();
  }
}
