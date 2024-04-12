// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice/data/datasources/notice_remote_data_source.dart';
import 'package:lokalio/features/notice/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late ReadNoticeRemoteDataSourceImpl dataSource;

  late MockFirestore mockFirestoreFirebase;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestoreFirebase = MockFirestore();
    dataSource = ReadNoticeRemoteDataSourceImpl(
        firebaseFirestore: mockFirestoreFirebase);

    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
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
    when(() => mockDocumentReference.get())
        .thenAnswer((_) => Future.value(mockQueryDocumentSnapshot));
    when(() => mockQueryDocumentSnapshot.exists).thenReturn(true);
  }

  const tNoticeId = '1';
  final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
    json: json.decode(fixture(name: 'notice_details.json')),
  );

  test(
    'should return NoticeDetails from Firebase when the call is successful',
    () async {
      setUp200();
      when(() => mockQueryDocumentSnapshot.data())
          .thenReturn(tNoticeDetailsModel.toJson());

      final result = await dataSource.readNotice(noticeId: tNoticeId);

      expect(result, equals(tNoticeDetailsModel));
    },
  );

  test('should throw ServerException when the call is unsuccessful', () async {
    setUp200();
    when(() => mockDocumentReference.get()).thenThrow(ServerException());

    final call = dataSource.readNotice;

    expect(() async => await call(noticeId: tNoticeId),
        throwsA(isA<ServerException>()));
  });

  test('should throw NoDataException when the document does not exist',
      () async {
    setUp200();
    when(() => mockQueryDocumentSnapshot.exists).thenReturn(false);

    final call = dataSource.readNotice;

    expect(() async => await call(noticeId: tNoticeId),
        throwsA(isA<NoDataException>()));
  });
}
