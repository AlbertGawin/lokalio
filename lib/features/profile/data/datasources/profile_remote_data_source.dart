import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> readProfile({required String profileId});
  Future<ProfileModel> readMyProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<ProfileModel> readProfile({required String profileId}) async {
    final docRef = firebaseFirestore.collection('profile').doc(profileId);
    return await docRef.get().then(
      (DocumentSnapshot doc) {
        if (!doc.exists) {
          throw NoDataException();
        }

        final json = doc.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(json: json);
      },
      onError: (e) {
        throw ServerException();
      },
    );
  }

  @override
  Future<ProfileModel> readMyProfile() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(message: 'User not found', code: '');
    }

    final docRef = firebaseFirestore.collection('profile').doc(user.uid);
    return await docRef.get().then(
      (DocumentSnapshot doc) {
        if (!doc.exists) {
          throw NoDataException();
        }

        final json = doc.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(json: json);
      },
      onError: (e) {
        throw ServerException();
      },
    );
  }
}
