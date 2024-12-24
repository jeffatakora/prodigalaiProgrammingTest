import 'package:flutter/foundation.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/service/auth_services.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;

  AuthenticationProvider(this._authService) {
    _initializeUser();
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> _initializeUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // Load user data from Firestore
      _user = await _authService.getUserData(currentUser.uid);
      notifyListeners();
    }
  }

  Future<bool> login(String username) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await _authService.signInAnonymously(username);

      _isLoading = false;
      notifyListeners();

      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
