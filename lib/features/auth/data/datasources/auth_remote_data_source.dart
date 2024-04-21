import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalio/core/cache/cache.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

abstract class AuthRemoteDataSource {
  Stream<Profile> get profile;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signInAnonymously();
  Future<void> signUp({required String email, required String password});
  Future<void> signOut();
  Future<void> addProfileData({
    required String username,
    required String phoneNumber,
    required String city,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final GoogleSignIn googleSignIn;
  final CacheClient cache;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.googleSignIn,
    required this.cache,
  });

  @visibleForTesting
  static const profileCacheKey = '__profile_cache_key__';

  @override
  Stream<Profile> get profile {
    return firebaseAuth.userChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return Profile.empty;
      } else {
        final doc = await firebaseFirestore
            .collection('profile')
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists) {
          final profile = ProfileModel.fromJson(json: doc.data()!);
          cache.write<Profile>(key: profileCacheKey, value: profile);
          return profile;
        } else {
          return Profile.empty;
        }
      }
    });
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    late final AuthCredential credential;

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

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
        final profile = user.toProfile;

        final profileRef =
            firebaseFirestore.collection('profile').doc(profile.id);

        await profileRef.set(profile.toJson()).onError((error, stackTrace) {
          throw UnknownException();
        });
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> addProfileData({
    required String username,
    required String phoneNumber,
    required String city,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          message: 'User not found',
          code: 'user-not-found',
        );
      }

      final profileRef = firebaseFirestore.collection('profile').doc(user.uid);

      await firebaseAuth.currentUser!
          .updateDisplayName(username)
          .onError((error, stackTrace) => throw UnknownException());

      await profileRef.update({
        'username': username,
        'phoneNumber': phoneNumber,
        'city': city,
      }).onError((error, stackTrace) => throw UnknownException());
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(message: e.message, code: e.code);
    }
  }
}

extension on firebase_auth.User {
  ProfileModel get toProfile {
    return ProfileModel(
      id: uid,
      username: displayName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      city: '',
      createdAt: Timestamp.now().seconds.toString(),
      imageUrl: photoURL,
    );
  }
}
