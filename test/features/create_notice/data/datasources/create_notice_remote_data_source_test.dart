// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockNoticeDetailsModel extends Mock implements NoticeDetailsModel {}

void main() {
  setupFirebaseAuthMocks();

  late CreateNoticeRemoteDataSourceImpl dataSource;

  late MockFirestore mockFirestoreFirebase;
  late MockFirebaseStorage mockFirebaseStorage;

  late MockReference mockReference;
  late MockUploadTask mockUploadTask;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockNoticeDetailsModel mockNoticeDetailsModel;

  setUp(() {
    mockFirestoreFirebase = MockFirestore();
    mockFirebaseStorage = MockFirebaseStorage();
    dataSource = CreateNoticeRemoteDataSourceImpl(
      firebaseFirestore: mockFirestoreFirebase,
      firebaseStorage: mockFirebaseStorage,
    );

    mockReference = MockReference();
    mockUploadTask = MockUploadTask();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockNoticeDetailsModel = MockNoticeDetailsModel();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
    registerFallbackValue(File(''));
  });

  const tId = '1';

  void setUp200() {
    when(() => mockFirestoreFirebase.collection(any()))
        .thenReturn(mockCollectionReference);
    when(() => mockFirebaseStorage.ref()).thenReturn(mockReference);
    when(() => mockReference.child(any())).thenReturn(mockReference);
    when(() => mockReference.putFile(any())).thenAnswer((_) => mockUploadTask);
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.id).thenReturn(tId);
    when(() => mockDocumentReference.set(any())).thenAnswer((_) async => true);
    when(() => mockNoticeDetailsModel.copyWith(id: any(named: "id")))
        .thenReturn(mockNoticeDetailsModel);
  }

  final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  test('should throw ServerException when the notice call is unsuccessful',
      () async {
    setUp200();
    when(() => mockDocumentReference.set(any())).thenThrow(ServerException());

    final call = dataSource.createNotice;

    expect(() async => await call(noticeDetails: tNoticeDetailsModel),
        throwsA(isA<ServerException>()));
  });

  test('should call notice and noticeDetails collection', () async {
    setUp200();

    await dataSource.createNotice(noticeDetails: tNoticeDetailsModel);

    verify(() => mockFirestoreFirebase.collection('notice'));
    verify(() => mockFirestoreFirebase.collection('noticeDetails'));
    verifyNoMoreInteractions(mockFirestoreFirebase);
  });
}
