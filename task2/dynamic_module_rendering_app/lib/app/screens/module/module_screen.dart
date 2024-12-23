import 'package:dynamic_module_rendering_app/app/provider/module_provider.dart';
import 'package:dynamic_module_rendering_app/app/screens/module/components/module_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ModulesProvider>(context, listen: false).loadModules();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Modules'),
      ),
      body: Consumer<ModulesProvider>(
        builder: (ctx, modulesProvider, child) {
          if (modulesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: modulesProvider.modules.length,
            itemBuilder: (ctx, index) {
              final module = modulesProvider.modules[index];
              return ModuleCard(module: module);
            },
          );
        },
      ),
    );
  }
}