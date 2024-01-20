// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late CreateNoticeRemoteDataSourceImpl dataSource;

  late MockFirestore mockFirestoreFirebase;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestoreFirebase = MockFirestore();
    dataSource = CreateNoticeRemoteDataSourceImpl(
        firebaseFirestore: mockFirestoreFirebase);

    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  void setUp200() {
    when(() => mockFirestoreFirebase.collection(any()))
        .thenReturn(mockCollectionReference);
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.set(any())).thenAnswer((_) async => true);
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
