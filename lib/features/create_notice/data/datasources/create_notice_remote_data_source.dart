import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';

abstract class CreateNoticeRemoteDataSource {
  Future<bool> createNotice({required NoticeDetailsModel noticeDetails});
}

class CreateNoticeRemoteDataSourceImpl implements CreateNoticeRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const CreateNoticeRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<bool> createNotice({
    required NoticeDetailsModel noticeDetails,
  }) async {
    final noticeRef =
        firebaseFirestore.collection('notice').doc(noticeDetails.id);
    final noticeDetailsRef =
        firebaseFirestore.collection('noticeDetails').doc(noticeDetails.id);

    return await noticeRef.set(noticeDetails.toNoticeMap()).then(
      (_) async {
        return await noticeDetailsRef.set(noticeDetails.toJson()).then(
          (_) {
            return true;
          },
          onError: (e) {
            throw ServerException();
          },
        );
      },
      onError: (e) {
        throw ServerException();
      },
    );
  }
}
