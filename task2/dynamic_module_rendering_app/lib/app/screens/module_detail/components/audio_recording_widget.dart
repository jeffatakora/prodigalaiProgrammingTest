import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_module_rendering_app/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// A stateful widget for recording audio, with controls to start/stop recording
/// and play the recorded audio.
class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _hasRecorded = false;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _initializeAudioRecorder();
  }

/// Initializes the audio recorder and requests microphone permissions.
  Future<void> _initializeAudioRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _audioRecorder.openRecorder();
    } else {
      Utils.showErrorDialog(
          // ignore: use_build_context_synchronously
          context,
          'Permission Denied',
          'Microphone permission is required.');
    }
  }

  @override
  void dispose() {
    if (_audioRecorder.isRecording) {
      _audioRecorder.stopRecorder();
    }
    _audioRecorder.stopRecorder();
    _audioRecorder.closeRecorder();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

/// Starts audio recording and saves the recording path.
  void _startRecording() async {
    final dir = await getTemporaryDirectory();
    String path = Platform.isAndroid
        ? '${dir.path}/dynamic_module_audio.aac'
        : '${dir.path}/recorded_audio.m4a';
    await _audioRecorder.startRecorder(
      toFile: path,
    );
    setState(() {
      _isRecording = true;
      _recordedAudioPath = path;
    });
  }

/// Stops the audio recording.
  void _stopRecording() async {
    await _audioRecorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _hasRecorded = true;
    });
  }

/// Plays the recorded audio.
  void _playRecordedAudio() async {
    if (_recordedAudioPath != null) {
      final file = File(_recordedAudioPath!);
      if (!file.existsSync()) {
        print('Error: Recorded file does not exist');
        return;
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Instructions for starting the recording.
        Text(
          'Start your recording',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Button to start/stop recording.
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                size: 32,
              ),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            if (_hasRecorded)
            /// Button to play/pause recorded audio.
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                ),
                onPressed: _playRecordedAudio,
              ),
          ],
        ),
      ],
    );
  }
}
