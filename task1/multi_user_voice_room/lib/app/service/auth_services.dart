import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_user_voice_room/app/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

// Sign in anonymously with username
  Future<UserModel?> signInAnonymously(String username) async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      final User? user = result.user;
      // Generate Agora ID for the user
      final int agoraId = generateAgoraId(user!.uid);

      final userModel =
          UserModel(uid: user.uid, username: username, agoraId: agoraId);

      // Create user document in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
        } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}

// Generate a unique Agora ID for a user
int generateAgoraId(String uid) {
  final Map<String, int> userAgoraIds = {};
  if (userAgoraIds.containsKey(uid)) {
    return userAgoraIds[uid]!;
  }

  // Generate a random number between 1 and 999999
  // Avoid using 0 as it might be reserved
  final int agoraId = DateTime.now().millisecondsSinceEpoch % 999999 + 1;
  userAgoraIds[uid] = agoraId;
  return agoraId;
}
