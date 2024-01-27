// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/exceptions.dart';
import 'package:lokalio/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late ProfileRemoteDataSourceImpl dataSource;

  late MockFirestore mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;

  late MockUser mockUser;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = ProfileRemoteDataSourceImpl(
      firebaseFirestore: mockFirestore,
      firebaseAuth: mockFirebaseAuth,
    );

    mockUser = MockUser();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  const tProfileId = '1';
  final tProfile = ProfileModel.fromJson(
    json: json.decode(fixture(name: 'profile.json')),
  );

  void setUp200() {
    when(() => mockFirestore.collection(any()))
        .thenReturn(mockCollectionReference);
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.get())
        .thenAnswer((_) => Future.value(mockQueryDocumentSnapshot));
    when(() => mockQueryDocumentSnapshot.exists).thenReturn(true);
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(tProfileId);
  }

  group('getProfile', () {
    test('should return Profile from Firebase when the call is successful',
        () async {
      setUp200();
      when(() => mockQueryDocumentSnapshot.data())
          .thenReturn(tProfile.toJson());

      final result = await dataSource.readProfile(profileId: tProfileId);

      expect(result, equals(tProfile));
    });

    test('should throw ServerException when the call is unsuccessful',
        () async {
      setUp200();
      when(() => mockDocumentReference.get()).thenThrow(ServerException());

      final call = dataSource.readProfile;

      expect(() async => await call(profileId: tProfileId),
          throwsA(isA<ServerException>()));
    });

    test('should throw NoDataException when the document does not exist',
        () async {
      setUp200();
      when(() => mockQueryDocumentSnapshot.exists).thenReturn(false);

      final call = dataSource.readProfile;

      expect(() async => await call(profileId: tProfileId),
          throwsA(isA<NoDataException>()));
    });
  });

  group('getMyProfile', () {
    test('should return Profile from Firebase when the call is successful',
        () async {
      setUp200();
      when(() => mockQueryDocumentSnapshot.data())
          .thenReturn(tProfile.toJson());

      final result = await dataSource.readMyProfile();

      expect(result, equals(tProfile));
    });

    test('should throw ServerException when the call is unsuccessful',
        () async {
      setUp200();
      when(() => mockDocumentReference.get()).thenThrow(ServerException());

      final call = dataSource.readMyProfile;

      expect(() async => await call(), throwsA(isA<ServerException>()));
    });

    test('should throw NoDataException when the document does not exist',
        () async {
      setUp200();
      when(() => mockQueryDocumentSnapshot.exists).thenReturn(false);

      final call = dataSource.readMyProfile;

      expect(() async => await call(), throwsA(isA<NoDataException>()));
    });
  });
}
