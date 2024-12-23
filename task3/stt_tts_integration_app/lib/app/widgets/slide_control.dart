import 'package:flutter/material.dart';

class SliderControl extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  const SliderControl({super.key, 
    required this.label,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: Colors.grey[800],
            thumbColor: activeColor,
            overlayColor: activeColor.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
