import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({required AuthCredential credential});
  Future<void> signInAnonymously();
  Future<void> signUp({required String email, required String password});
  Future<void> signOut();
  Future<void> setProfileInfo({
    required String name,
    required String phone,
    required String smsCode,
  });
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
          name: user.displayName ?? '',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
        );

        final profileRef =
            firebaseFirestore.collection('profile').doc(profile.id);
        await profileRef.set(profile.toJson());
      }
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

  @override
  Future<void> setProfileInfo({
    required String name,
    required String phone,
    required String smsCode,
  }) async {
    try {
      ProfileModel profile = ProfileModel(
        id: firebaseAuth.currentUser!.uid,
        name: name,
        email: firebaseAuth.currentUser!.email!,
        phoneNumber: phone,
      );

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _updateProfile(profile, credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw FirebaseAuthException(message: e.message, code: e.code);
        },
        codeSent: (String verificationId, int? resendToken) async {
          final credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          await _updateProfile(profile, credential);
        },
        codeAutoRetrievalTimeout: (String verId) {
          throw FirebaseAuthException(
              message: 'The verification code has expired.', code: 'timeout');
        },
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  Future<void> _updateProfile(
    ProfileModel profile,
    PhoneAuthCredential credential,
  ) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(profile.name);
      await firebaseAuth.currentUser!.updatePhoneNumber(credential);

      await signIn(credential: credential);

      final profileRef =
          firebaseFirestore.collection('profile').doc(profile.id);
      await profileRef.set(profile.toJson());
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }
}
