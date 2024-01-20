import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';

abstract class CreateNoticeRemoteDataSource {
  Future<void> createNotice({required NoticeDetailsModel noticeDetails});
}

class CreateNoticeRemoteDataSourceImpl implements CreateNoticeRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const CreateNoticeRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<void> createNotice({required NoticeDetailsModel noticeDetails}) async {
    final noticeRef = firebaseFirestore.collection('notice').doc();

    if (noticeDetails.imagesUrl != null) {
      final List<String> imagesUrl = [];
      final storageRef = FirebaseStorage.instance.ref();

      int index = 0;
      for (final image in noticeDetails.imagesUrl!) {
        final uploadTask = storageRef
            .child('noticeImages/${noticeRef.id}/$index.webp')
            .putFile(File(image));
        await uploadTask.whenComplete(() async {
          final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
          imagesUrl.add(imageUrl);
          index++;
        }).onError((error, stackTrace) => throw ServerException());
      }
      noticeDetails = noticeDetails.copyWith(imagesUrl: imagesUrl);
    }

    await noticeRef.set(noticeDetails.toNoticeMap(id: noticeRef.id)).then(
      (_) async {
        final noticeDetailsRef =
            firebaseFirestore.collection('noticeDetails').doc(noticeRef.id);
        await noticeDetailsRef
            .set(noticeDetails.toJson(id: noticeDetailsRef.id))
            .then(
          (_) {
            return;
          },
        ).onError((error, stackTrace) => throw ServerException());
      },
    ).onError((error, stackTrace) => throw ServerException());
  }
}
