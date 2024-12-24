import 'package:flutter/material.dart';
import 'package:stt_tts_integration_app/app/widgets/custom_text.dart';

/// Custom widget to display a card with an image, title, description, and on-tap action.
class CardItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String desc;
  final Function() onTap;
  const CardItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.desc,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section of the card
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                    maxLine: 2,
                    ellipsis: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: desc,
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[300],
                        ),
                    maxLine: 2,
                    ellipsis: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
