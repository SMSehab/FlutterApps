import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User Object locally based on Firebase User.
  UserObj _userFromFirebaseUser(User user) {
    return user != null ? UserObj(uid: user.uid) : null;
  }

  // User auth state stream
  Stream<UserObj> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Anonymous sign in (not used)
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and passwork
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
    print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).setNewUserData(
        name: 'new user',
        bio: 'I am a new user.',
      );
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString);
      return null;
    }
  }
}
