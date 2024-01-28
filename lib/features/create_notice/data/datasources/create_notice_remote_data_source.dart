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
  final FirebaseStorage firebaseStorage;

  const CreateNoticeRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  @override
  Future<void> createNotice({required NoticeDetailsModel noticeDetails}) async {
    final noticeRef = firebaseFirestore.collection('notice').doc();
    noticeDetails = noticeDetails.copyWith(id: noticeRef.id);

    if (noticeDetails.imagesUrl != null) {
      noticeDetails = await _uploadImages(
        images: noticeDetails.imagesUrl!,
        noticeDetails: noticeDetails,
      );
    }

    await noticeRef.set(noticeDetails.toNoticeJson()).then(
      (_) async {
        final noticeDetailsRef =
            firebaseFirestore.collection('noticeDetails').doc(noticeRef.id);
        await noticeDetailsRef.set(noticeDetails.toJson());
      },
    ).onError((error, stackTrace) => throw ServerException());
  }

  Future<NoticeDetailsModel> _uploadImages({
    required List<String> images,
    required NoticeDetailsModel noticeDetails,
  }) async {
    final List<String> imagesUrl = [];
    final storageRef = firebaseStorage.ref();

    int index = 0;
    for (final image in images) {
      final uploadTask = storageRef
          .child('noticeImages/${noticeDetails.id}/$index.webp')
          .putFile(File(image));
      await uploadTask.whenComplete(() async {
        final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
        imagesUrl.add(imageUrl);
        index++;
      }).onError((error, stackTrace) => throw ServerException());
    }
    return noticeDetails.copyWith(imagesUrl: imagesUrl);
  }
}
