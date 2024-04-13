import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String userId});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const ProfileRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<ProfileModel> getProfile({required String userId}) async {
    final docRef = firebaseFirestore.collection('profile').doc(userId);

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
    ).onError((error, stackTrace) {
      throw ServerException();
    });
  }
}
