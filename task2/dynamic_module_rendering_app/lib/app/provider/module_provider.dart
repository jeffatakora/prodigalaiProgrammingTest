import 'dart:convert';

import 'package:dynamic_module_rendering_app/app/model/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModulesProvider with ChangeNotifier {
  List<Module> _modules = [];
  bool _isLoading = false;

  List<Module> get modules => [..._modules];
  bool get isLoading => _isLoading;

  ModulesProvider() {
    loadModules(); // Automatically load modules
  }

  Future<void> loadModules() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String response =
          await rootBundle.loadString('/Users/jeff/FlutterProjects/flutter_developer_test_assignment/task2/dynamic_module_rendering_app/assets/json/modules.json');
      final data = json.decode(response);

      _modules = (data['modules'] as List)
          .map((module) => Module.fromJson(module))
          .toList();

      print("Modules loaded successfully: ${_modules.length} modules");
    } catch (error, stackTrace) {
      print('Error loading modules: $error');
      print(stackTrace); // Logs stack trace for debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
