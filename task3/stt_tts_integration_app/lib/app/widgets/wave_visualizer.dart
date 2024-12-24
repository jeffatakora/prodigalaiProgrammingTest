import 'package:flutter/material.dart';

/// A customizable wave visualizer for displaying audio levels or animations.
///
/// This widget generates a wave-like visualization with customizable column
/// heights, widths, colors, and animation behavior.
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

  /// The height of each column in the visualizer.
  final double columnHeight;

  /// The width of each column in the visualizer.
  final double columnWidth;

  /// Whether the animation is paused.
  final bool isPaused;

  /// Width factor to control the wave visibility.
  final double widthFactor;

  /// Whether the center bar is visible.
  final bool isBarVisible;

  /// The color of the wave and the bar.
  final Color color;

  final List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    /// Initial column heights for the wave when paused.
    final List<double> initialHeight = [
      columnHeight / 3,
      columnHeight / 1.5,
      columnHeight,
      columnHeight / 1.5,
      columnHeight / 3
    ];
    return Stack(
      // Static background wave visualization.
      children: [
        SizedBox(
          height: columnHeight,
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
                    initialHeight: isPaused ? initialHeight[index % 5] : null,
                    color: index % 2 == 0
                        ? color.withOpacity(0.1)
                        : color.withOpacity(0.03),
                  ),
                ),
              ),
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
        // Animated foreground wave visualization.
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
                  isBarVisible
                      ? Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
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
          ),
        ),
      ],
    );
  }
}

/// A single column in the wave visualizer that animates between a minimum and maximum height.
///
/// The `VisualComponent` is used to create the wave effect by animating its height.
/// It uses a `Tween` to animate the height changes over a specified duration.
class VisualComponent extends StatefulWidget {
  const VisualComponent({
    super.key,
    required this.duration,
    required this.color,
    required this.height,
    required this.width,
    this.initialHeight,
  });

  /// Duration of the height animation in milliseconds.
  final int duration;

  /// The color of the column.
  final Color color;

  /// The maximum height of the column.
  final double height;

  /// The width of the column.
  final double width;

  /// The initial height of the column when paused.
  final double? initialHeight;

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  /// The height animation.
  late final Animation<double> animation;

  /// Controller for the animation.
  late final AnimationController animController;

  @override
  void initState() {
    // Initialize the animation controller with the specified duration.
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    // Create a curved animation for smoother height transitions.
    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    // Define the height animation using a Tween.
    animation = Tween<double>(
      begin: 20,
      end: widget.height,
    ).animate(curvedAnimation)
      ..addListener(() {
        // Rebuild the widget when the animation value changes.
        setState(() {});
      });

    // Repeat the animation in reverse to create a pulsating effect.
    animController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is removed from the tree.
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
