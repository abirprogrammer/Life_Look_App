import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/app_models.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<AppUser?> get authStateChanges {
    try {
      return _auth.authStateChanges().map((user) {
        if (user == null) return null;
        return AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'LifeLoop User',
          photoUrl: user.photoURL,
        );
      });
    } catch (_) {
      // Fallback for uninitialized Firebase in test or local environments
      return Stream.value(null);
    }
  }

  AppUser? get currentUser {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'LifeLoop User',
        photoUrl: user.photoURL,
      );
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;
      return AppUser(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName ?? 'LifeLoop User',
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AppUser> registerWithEmail(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      final user = credential.user!;
      return AppUser(
        uid: user.uid,
        email: user.email ?? email,
        displayName: name,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final fb.UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Google User',
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (_) {}
  }
}
