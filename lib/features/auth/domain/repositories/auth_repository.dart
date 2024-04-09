import '../entities/user.dart';

abstract class AuthRepository {
  Stream<User> get user;
  User get currentUser;

  Future<void> signUp({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signInAnonymously();
  Future<void> signOut();
}
