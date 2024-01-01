import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_details/data/models/notice_details.dart';

abstract class NoticeDetailsRemoteDataSource {
  Future<NoticeDetailsModel> getNoticeDetails({required String id});
}

class NoticeDetailsRemoteDataSourceImpl
    implements NoticeDetailsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  NoticeDetailsRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<NoticeDetailsModel> getNoticeDetails({required String id}) async {
    final docRef = firebaseFirestore.collection('noticeDetails').doc(id);
    return await docRef.get().then(
      (DocumentSnapshot doc) {
        final json = doc.data() as Map<String, dynamic>;
        return NoticeDetailsModel.fromJson(json: json);
      },
      onError: (e) {
        throw ServerException();
      },
    );
  }
}
