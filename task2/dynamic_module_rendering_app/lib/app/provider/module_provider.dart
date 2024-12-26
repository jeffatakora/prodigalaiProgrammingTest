import 'dart:convert';

import 'package:dynamic_module_rendering_app/app/model/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Provider class to manage the state of modules and notify listeners about changes.
class ModulesProvider with ChangeNotifier {
  List<Module> _modules = []; // List of all loaded modules.
  bool _isLoading = false; // Indicates whether modules are being loaded.
  /// Getter to retrieve the list of modules.
  List<Module> get modules => [..._modules];

  /// Getter to check the loading state.
  bool get isLoading => _isLoading;

  /// Constructor to initialize the provider and load modules automatically.
  ModulesProvider() {
    loadModules(); // Automatically load modules on creation.
  }

  /// Asynchronous method to load modules from a local JSON file.
  Future<void> loadModules() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String response =
          await rootBundle.loadString('assets/json/modules.json');
      final data = json.decode(response);

      _modules = (data['modules'] as List)
          .map((module) => Module.fromJson(module))
          .toList();

      debugPrint("Modules loaded successfully: ${_modules.length} modules");
    } catch (error, stackTrace) {
      debugPrint('Error loading modules: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
