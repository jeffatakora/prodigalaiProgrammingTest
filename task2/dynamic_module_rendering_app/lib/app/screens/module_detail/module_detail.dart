import 'package:dynamic_module_rendering_app/app/model/module.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/audio_cake_widget.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/image_cake_widget.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/components/text_cake_widget.dart';
import 'package:flutter/material.dart';

class ModuleDetailScreen extends StatelessWidget {
  final Module module;

  const ModuleDetailScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: module.cakes.length,
        itemBuilder: (ctx, index) {
          final cake = module.cakes[index];
          switch (cake.type) {
            case 'text':
              return TextCakeWidget(cake: cake);
            case 'audio':
              return AudioCakeWidget(cake: cake);
            case 'image':
              return ImageCakeWidget(cake: cake);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
