import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({required AuthCredential credential});
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

  const AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<void> signIn({required AuthCredential credential}) async {
    try {
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
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
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await updateProfile(name, credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw FirebaseAuthException(message: e.message, code: e.code);
        },
        codeSent: (String verificationId, int? resendToken) async {
          final credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          await updateProfile(name, credential);
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

  Future<void> updateProfile(
      String name, PhoneAuthCredential credential) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(name);
      await firebaseAuth.currentUser!.updatePhoneNumber(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }
}
