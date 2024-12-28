import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/model/user.dart';

/// Manages authentication-related operations and user state.
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Authentication instance.
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance for database operations.
  UserModel? _user; // Currently authenticated user.
  bool _isLoading = false; // Loading state indicator.

  /// Getter for the current authenticated user.
  UserModel? get user => _user;

  /// Getter for the loading state.
  bool get isLoading => _isLoading;

  /// Signs in the user anonymously with a given username and saves the user to Firestore.
  Future<bool> signInWithUsername(String username) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.signInAnonymously();
      final uid = result.user!.uid;
      final agoraId = DateTime.now().millisecondsSinceEpoch % 100000;

      final userModel = UserModel(
        uid: uid,
        username: username,
        agoraId: agoraId,
      );

      await _firestore.collection('users').doc(uid).set(userModel.toMap());
      _user = userModel;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Retrieves the current authenticated user from Firestore.
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!);
        return _user;
      }
    }
    return null;
  }

/// Signs out the current user and updates the local state.
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
