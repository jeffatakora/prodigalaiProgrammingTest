import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:livespeechtotext/livespeechtotext.dart';
import 'package:stt_tts_integration_app/app/utils/app_colors.dart';
import 'package:stt_tts_integration_app/app/widgets/circular_button.dart';
import 'package:stt_tts_integration_app/app/widgets/custom_text.dart';
import 'package:stt_tts_integration_app/app/widgets/wave_visualizer.dart';

/// Screen for Speech-to-Text functionality.
class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late Livespeechtotext _livespeechtotextPlugin;
  late String _recognisedText;
  StreamSubscription<dynamic>? onSuccessEvent;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _livespeechtotextPlugin = Livespeechtotext();

// Subscribes to the speech-to-text success events.
    onSuccessEvent =
        _livespeechtotextPlugin.addEventListener('success', (text) {
      setState(() {
        _recognisedText = text;
        // _recognisedText = text ?? '';
      });
    });

    _recognisedText = '';

    // binding().whenComplete(() => null);
  }

  /// Starts the speech recognition process.
  void _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      _livespeechtotextPlugin.start();
    }
  }

  /// Stops the speech recognition process.
  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _livespeechtotextPlugin.stop();
    }
  }

  Future<dynamic> binding() async {
    onSuccessEvent?.cancel();

    // listen to event "success"
    onSuccessEvent =
        _livespeechtotextPlugin.addEventListener("success", (value) {
      setState(() {
        _recognisedText = value;
      });
    });

    setState(() {});
  }

  @override
  void dispose() {
    // Cancels the subscription to events and performs cleanup.
    onSuccessEvent?.cancel();
    super.dispose();
  }

  /// Builds the UI for the Speech-to-Text screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header row with back button and title.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back,
                        color: AppColors.kWhite,
                      )),
                  const CustomText(
                    text: 'Speech to Text',
                    txtColor: Colors.white,
                    font: 24,
                    fntweight: FontWeight.bold,
                  ),
                  const SizedBox()
                ],
              ),
              const SizedBox(height: 40),
              // Gesture detector for the microphone.
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 150,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Display message indicating the listening state.
              CustomText(
                text: _isListening ? 'Tap to stop' : 'Tap to record',
                txtColor: Colors.grey[600],
                font: 16,
              ),
              const SizedBox(height: 40),
              // Wave visualizer for speech input.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: WaveVisualizer(
                    columnHeight: 50,
                    columnWidth: 4,
                    isPaused: !_isListening,
                    isBarVisible: false,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Display recognized text.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Text:',
                      font: 16,
                      fntweight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: _recognisedText.isEmpty
                          ? 'Start speaking to see the text here...'
                          : _recognisedText,
                      txtColor:
                          _recognisedText.isEmpty ? Colors.grey : Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularButton(
                          icon: Icons.delete_outline,
                          color: AppColors.kRed,
                          onPressed: () {
                            setState(() => _recognisedText = '');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
