import 'package:flutter/material.dart';

/// A widget that visually represents audio waveforms with animated columns.
///
/// Can display a paused or playing state, adjust column dimensions, and optionally
/// show a central bar for alignment.
class WaveVisualizer extends StatelessWidget {
  WaveVisualizer({
    super.key,
    required this.columnHeight,
    required this.columnWidth,
    this.isPaused = true,
    this.widthFactor = 1,
    this.isBarVisible = true,
    this.color = Colors.black,
  });

  /// The height of the columns representing the wave.
  final double columnHeight;

  /// The width of the columns representing the wave.
  final double columnWidth;

  /// Indicates whether the visualizer is in a paused state
  final bool isPaused;

  /// The fractional width factor for the visible part of the wave.
  final double widthFactor;

  /// Indicates whether the central alignment bar is visible.
  final bool isBarVisible;

  /// The color of the wave and bar elements.
  final Color color;

  /// Predefined durations for the animation of each column.
  final List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    // Initial heights for columns when the visualizer is paused.
    final List<double> initialHeight = [
      columnHeight / 3,
      columnHeight / 1.5,
      columnHeight,
      columnHeight / 1.5,
      columnHeight / 3
    ];
    return Stack(
      children: [
        SizedBox(
          height: columnHeight,
          child: Stack(
            children: [
              // Generates static columns with opacity variations for visual effects.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  10,
                  (index) => VisualComponent(
                    width: columnWidth,
                    height: columnHeight,
                    duration: duration[index % 5],
                    initialHeight: isPaused ? initialHeight[index % 5] : null,
                    color: index % 2 == 0
                        ? color.withOpacity(0.1)
                        : color.withOpacity(0.03),
                  ),
                ),
              ),
              // Displays the central bar if `isBarVisible` is true.
              isBarVisible
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: double.maxFinite,
                        height: 4,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        // Clip the visible area of the animated wave based on `widthFactor`.
        SizedBox(
          height: columnHeight,
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: widthFactor,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(
                      10,
                      (index) => VisualComponent(
                        width: columnWidth,
                        height: columnHeight,
                        duration: duration[index % 5],
                        initialHeight:
                            isPaused ? initialHeight[index % 5] : null,
                        color: index % 2 == 0 ? color : color.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Displays the central alignment bar with the main color if `isBarVisible` is true.
                  if (isBarVisible)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: double.maxFinite,
                        height: 4,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single column component used in the `WaveVisualizer`.
///
/// This component animates its height between a minimum and maximum value.
class VisualComponent extends StatefulWidget {
  const VisualComponent({
    super.key,
    required this.duration,
    required this.color,
    required this.height,
    required this.width,
    this.initialHeight,
  });

  /// The duration of the height animation in milliseconds.
  final int duration;

  /// The color of the column.
  final Color color;

  /// The maximum height of the column.
  final double height;

  /// The width of the column.
  final double width;

  /// The initial height of the column when the visualizer is paused.
  final double? initialHeight;

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController animController;

  @override
  void initState() {
    super.initState();
    // Initializes the animation controller with the specified duration.
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    // Defines a curved animation for smooth height transitions.
    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    // Configures the animation to oscillate between a minimum and maximum height.
    animation = Tween<double>(
      begin: 20,
      end: widget.height,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    // Repeats the animation indefinitely in a reverse cycle.
    animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    // Disposes of the animation controller when the widget is destroyed.
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.initialHeight ?? animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
