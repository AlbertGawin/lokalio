import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/features/home/data/models/notice.dart';

abstract class NoticeListRemoteDataSource {
  Future<List<NoticeModel>> getAllNotices();
  Future<List<NoticeModel>> getUserNotices({required String userId});
}

class NoticeListRemoteDataSourceImpl implements NoticeListRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  NoticeListRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<List<NoticeModel>> getAllNotices() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(message: 'User not found', code: '');
    }

    final query = await firebaseFirestore
        .collection('notices')
        .where('userId', isNotEqualTo: user.uid)
        .get();

    final notices = query.docs.map((snapshot) {
      return NoticeModel.fromJson(json: snapshot.data());
    }).toList();

    return notices;
  }

  @override
  Future<List<NoticeModel>> getUserNotices({required String userId}) async {
    final query = await firebaseFirestore
        .collection('notices')
        .where('userId', isEqualTo: userId)
        .get();

    final notices = query.docs.map((snapshot) {
      return NoticeModel.fromJson(json: snapshot.data());
    }).toList();

    return notices;
  }
}
