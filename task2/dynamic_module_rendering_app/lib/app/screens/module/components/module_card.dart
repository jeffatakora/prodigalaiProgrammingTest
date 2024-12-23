import 'package:dynamic_module_rendering_app/app/model/module.dart';
import 'package:dynamic_module_rendering_app/app/screens/module_detail/module_detail.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final Module module;

  const ModuleCard({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ModuleDetailScreen(module: module),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    module.imageUrl,
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
                    Text(
                      module.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class ModuleCard extends StatelessWidget {
//   final Module module;

//   const ModuleCard({required this.module, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: InkWell(
//         onTap: () => Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) => ModuleDetailScreen(module: module),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Module Image
//             SizedBox(
//               width: 100,
//               height: 100,
//               child: Image.asset(
//                 module.imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   // Fallback if the image fails to load
//                   return const Icon(Icons.broken_image, size: 50);
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Module Details
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize
//                       .min, // Prevents Column from expanding infinitely
//                   children: [
//                     Text(
//                       module.title,
//                       style: Theme.of(context).textTheme.titleMedium,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       module.description,
//                       style: Theme.of(context).textTheme.bodySmall,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
