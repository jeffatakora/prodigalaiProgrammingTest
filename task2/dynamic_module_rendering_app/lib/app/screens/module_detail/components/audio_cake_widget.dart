import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_module_rendering_app/app/model/cake.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/wave_visualizer.dart';
import 'package:flutter/material.dart';

class AudioCakeWidget extends StatefulWidget {
  final Cake cake;

  const AudioCakeWidget({super.key, required this.cake});

  @override
  State<AudioCakeWidget> createState() => _AudioCakeWidgetState();
}

class _AudioCakeWidgetState extends State<AudioCakeWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(
          widget.cake.audioUrl!)); // Assuming content is the file path
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

String _formatDuration(Duration currentPosition, Duration totalDuration) {
    Duration remainingDuration = totalDuration - currentPosition;
    String minutes = remainingDuration.inMinutes.toString().padLeft(2, '0');
    String seconds =
        (remainingDuration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cake.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(widget.cake.content),
            const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0),
            //   child: SizedBox(
            //     height: 60,
            //     width: double.maxFinite,
            //     child: WaveVisualizer(
            //       columnHeight: 50,
            //       columnWidth: 10,
            //       isPaused: false,
            //       isBarVisible: false,
            //       color: Colors.red.shade600,
            //     ),
            //   ),
            // ),
            //audio player ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  onPressed: _playAudio,
                ),
                 Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Simulated waveform (replace with actual waveform plugin if needed)
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: WaveVisualizer(
                          columnHeight: 50,
                          columnWidth: 4,
                          isPaused: !_isPlaying,
                          isBarVisible: false,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_currentPosition, _audioDuration),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (widget.cake.requiresRecording == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Implement recording
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
