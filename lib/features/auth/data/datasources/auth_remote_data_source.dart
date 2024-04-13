import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({required AuthCredential credential});
  Future<void> signInAnonymously();
  Future<void> signUp({required String email, required String password});
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<void> signIn({required AuthCredential credential}) async {
    try {
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      await firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final profile = ProfileModel(
          id: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          city: '',
          createdAt: Timestamp.now().seconds.toString(),
          imageUrl: user.photoURL,
        );

        final profileRef =
            firebaseFirestore.collection('profile').doc(profile.id);

        await profileRef.set(profile.toJson()).onError((error, stackTrace) {
          throw UnknownException();
        });
      }

      throw UnknownException();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }
}
