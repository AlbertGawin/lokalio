// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/notice_details/data/datasources/notice_details_remote_data_source.dart';
import 'package:lokalio/features/notice_details/data/models/notice_details.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late NoticeDetailsRemoteDataSourceImpl dataSource;

  late MockFirestore mockFirestoreFirebase;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestoreFirebase = MockFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = NoticeDetailsRemoteDataSourceImpl(
      firebaseFirestore: mockFirestoreFirebase,
      firebaseAuth: mockFirebaseAuth,
    );

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
  }

  group('getNoticeDetails', () {
    const tId = '1';
    final tNoticeDetailsModel = NoticeDetailsModel.fromJson(
      json: json.decode(fixture(name: 'notice_details.json')),
    );

    test(
      'should return NoticeDetails from Firebase when the call is successful',
      () async {
        setUp200();
        when(() => mockQueryDocumentSnapshot.data())
            .thenReturn(tNoticeDetailsModel.toJson());

        final result = await dataSource.getNoticeDetails(id: tId);

        expect(result, equals(tNoticeDetailsModel));
      },
    );

    test('should throw ServerException when there is an error', () async {
      setUp200();
      when(() => mockDocumentReference.get())
          .thenAnswer((_) => Future.error(ServerException()));

      final call = dataSource.getNoticeDetails;

      expect(() async => await call(id: tId), throwsA(isA<ServerException>()));
    });
  });
}
