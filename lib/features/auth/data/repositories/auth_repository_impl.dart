import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Profile> get profile => remoteDataSource.profile;

  @override
  Profile get currentProfile => localDataSource.currentProfile;

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await remoteDataSource.signUp(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await remoteDataSource.signInWithGoogle();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithGoogleFailure();
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      await remoteDataSource.signInAnonymously();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInAnonymouslyFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInAnonymouslyFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (_) {
      throw SignOutFailure();
    }
  }

  @override
  Future<void> addProfileData({
    required String username,
    required String phoneNumber,
    required String city,
  }) async {
    try {
      await remoteDataSource.addProfileData(
        username: username,
        phoneNumber: phoneNumber,
        city: city,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure(message: e.code);
    } catch (_) {
      throw const AddProfileDataFailure();
    }
  }
}
