import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_crud/data/models/notice_details.dart';

abstract class NoticeCRUDRemoteDataSource {
  Future<NoticeDetailsModel> readNotice({required String noticeId});
}

class NoticeCRUDRemoteDataSourceImpl implements NoticeCRUDRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const NoticeCRUDRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<NoticeDetailsModel> readNotice({required String noticeId}) async {
    final docRef = firebaseFirestore.collection('noticeDetails').doc(noticeId);
    return await docRef.get().then(
      (DocumentSnapshot doc) {
        if (!doc.exists) {
          throw NoDataException();
        }

        final json = doc.data() as Map<String, dynamic>;
        return NoticeDetailsModel.fromJson(json: json);
      },
      onError: (e) {
        throw ServerException();
      },
    );
  }
}
