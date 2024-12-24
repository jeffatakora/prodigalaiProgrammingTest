import 'package:flutter/material.dart';
import 'package:stt_tts_integration_app/app/widgets/custom_text.dart';

/// A widget to display a labeled slider control for adjusting settings.
///
/// This widget allows the user to adjust a value (e.g., speed, pitch, volume)
/// using a slider. The label and the color of the slider can be customized.
class SliderControl extends StatelessWidget {
  /// The label displayed above the slider.
  final String label;
  /// The current value of the slider.
  final double value;
  /// Callback to update the value.
  final ValueChanged<double> onChanged;
  /// The active track and thumb color of the slider.
  final Color activeColor;

  const SliderControl({
    super.key,
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
          child: CustomText(
            text: label,
            txtColor: Colors.white70,
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
