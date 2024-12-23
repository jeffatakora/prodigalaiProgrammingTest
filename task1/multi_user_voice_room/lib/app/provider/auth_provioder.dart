import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:uuid/uuid.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  void login(String username) {
    _currentUser = User(
      id: const Uuid().v4(),
      username: username,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
