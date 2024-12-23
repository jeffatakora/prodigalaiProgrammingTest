import 'package:dynamic_module_rendering_app/app/provider/module_provider.dart';
import 'package:dynamic_module_rendering_app/app/screens/module/module_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModulesProvider(),
      child: MaterialApp(
        title: 'Learning App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ModulesScreen(),
      ),
    );
  }
}
