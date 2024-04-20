import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/core/util/compress_image.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';

abstract class CreateNoticeRemoteDataSource {
  Future<void> createNotice({required NoticeDetailsModel noticeDetails});
}

class CreateNoticeRemoteDataSourceImpl implements CreateNoticeRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;

  const CreateNoticeRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseStorage,
    required this.firebaseAuth,
  });

  @override
  Future<void> createNotice({required NoticeDetailsModel noticeDetails}) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(message: 'User not found', code: '');
    }

    final noticeRef = firebaseFirestore.collection('notice').doc();
    noticeDetails = noticeDetails.copyWith(id: noticeRef.id, userId: user.uid);

    final String thumbnailUrl = await _uploadThumbnail(
      noticeId: noticeDetails.id,
      thumbnailPath: noticeDetails.imagesUrl[0],
    );

    final List<String> imagesUrl = await _uploadImages(
      noticeId: noticeDetails.id,
      images: noticeDetails.imagesUrl,
    );

    noticeDetails = noticeDetails.copyWith(imagesUrl: imagesUrl);

    await noticeRef
        .set(noticeDetails.toNoticeJson(thumbnailUrl: thumbnailUrl))
        .then(
      (_) async {
        final noticeDetailsRef =
            firebaseFirestore.collection('noticeDetails').doc(noticeRef.id);
        await noticeDetailsRef.set(noticeDetails.toJson());
      },
    ).onError((error, stackTrace) => throw ServerException());
  }

  Future<String> _uploadThumbnail({
    required String noticeId,
    required String thumbnailPath,
  }) async {
    final thumbnailRef =
        firebaseStorage.ref().child('noticeThumbnail/$noticeId.webp');
    final compressedImage = await compressImage(
      path: thumbnailPath,
      isThumbnail: true,
    );

    return await thumbnailRef
        .putFile(File(compressedImage))
        .then((_) => thumbnailRef.getDownloadURL())
        .onError((error, stackTrace) => throw ServerException());
  }

  Future<List<String>> _uploadImages({
    required String noticeId,
    required List<String> images,
  }) async {
    List<String> imagesUrl = [];

    for (var i = 0; i < images.length; i++) {
      final imageRef =
          firebaseStorage.ref().child('noticeImages/$noticeId/$i.webp');
      final compressedImage = await compressImage(path: images[i]);

      await imageRef.putFile(File(compressedImage)).then((_) async {
        imagesUrl.add(await imageRef.getDownloadURL());
      }).onError((error, stackTrace) => throw ServerException());
    }

    return imagesUrl;
  }
}
