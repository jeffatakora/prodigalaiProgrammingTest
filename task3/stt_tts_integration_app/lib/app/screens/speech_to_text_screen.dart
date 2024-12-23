import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livespeechtotext/livespeechtotext.dart';
import 'package:stt_tts_integration_app/app/widgets/circular_button.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late Livespeechtotext _livespeechtotextPlugin;
  late String _recognisedText;
  StreamSubscription<dynamic>? onSuccessEvent;
  final String _timeElapsed = '00:00:00';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _livespeechtotextPlugin = Livespeechtotext();

    onSuccessEvent =
        _livespeechtotextPlugin.addEventListener('success', (text) {
      setState(() {
        _recognisedText = text;
        // _recognisedText = text??'';
      });
    });

    _recognisedText = '';
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      _livespeechtotextPlugin.start();
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _livespeechtotextPlugin.stop();
    }
  }

  @override
  void dispose() {
    onSuccessEvent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Speech to Text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isListening ? 'Tap to stop' : 'Tap to record',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              if (_isListening || _recognisedText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _stopListening();
                          },
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: List.generate(
                              20,
                              (index) => Container(
                                width: 2,
                                height: _isListening ? 15.0 : 5.0,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _timeElapsed,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
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
                    const Text(
                      'Text:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _recognisedText.isEmpty
                          ? 'Start speaking to see the text here...'
                          : _recognisedText,
                      style: TextStyle(
                        color: _recognisedText.isEmpty
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularButton(
                          icon: Icons.delete_outline,
                          color: Colors.red,
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
      // Center(
      //   child: Column(
      //     children: [
      //       Text(_recognisedText),
      //       ElevatedButton(
      //           onPressed: () {
      //             print("start button pressed");
      //             try {
      //               _livespeechtotextPlugin.start();
      //             } on PlatformException {
      //               print('error');
      //             }
      //           },
      //           child: const Text('Start')),
      //       ElevatedButton(
      //           onPressed: () {
      //             print("stop button pressed");
      //             try {
      //               _livespeechtotextPlugin.stop();
      //             } on PlatformException {
      //               print('error');
      //             }
      //           },
      //           child: const Text('Stop')),
      //     ],
      //   ),
      // ),
    );
  }
}
