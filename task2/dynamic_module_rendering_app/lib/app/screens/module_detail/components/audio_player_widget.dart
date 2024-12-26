import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/wave_visualizer.dart';
import 'package:flutter/material.dart';

/// A stateful widget that provides functionality to play an audio file from a given URL.
/// Includes controls to play/pause audio and displays the remaining time.
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    /// Listens for audio duration changes.
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    /// Listens for position changes during playback.
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    /// Resets the playback state when the audio finishes.
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  /// Toggles the play/pause state of the audio player.
  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  /// Formats a [Duration] object into a "mm:ss" string format.
  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            size: 32,
          ),
          onPressed: _togglePlayPause,
        ),
        /// A visualizer for the audio player
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
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
        /// Displays the remaining audio duration.
        Text(
          _formatDuration(_audioDuration - _currentPosition),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
