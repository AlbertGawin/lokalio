import 'dart:async';

import 'package:lokalio/features/profile/domain/entities/profile.dart';

abstract class AuthRepository {
  Stream<Profile> get profile;
  Profile get currentProfile;

  Future<void> signUp({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signInAnonymously();
  Future<void> signOut();

  Future<void> addProfileData({
    required String username,
    required String phoneNumber,
    required String city,
  });
}
