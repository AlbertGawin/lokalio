// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late AuthRemoteDataSourceImpl dataSource;

  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = AuthRemoteDataSourceImpl(firebaseAuth: mockFirebaseAuth);

    mockUserCredential = MockUserCredential();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  const tEmail = 'test';
  const tPassword = 'test';

  group('signIn', () {
    test('should sign in with email and password', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => mockUserCredential);

      await dataSource.signIn(email: tEmail, password: tPassword);

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail, password: tPassword));
    });

    test('should throw FirebaseAuthException when sign in fails', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'code', message: 'message'));

      expect(() => dataSource.signIn(email: tEmail, password: tPassword),
          throwsA(isA<FirebaseAuthException>()));
    });
  });

  group('signUp', () {
    test('should sign up with email and password', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => mockUserCredential);

      await dataSource.signUp(email: tEmail, password: tPassword);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword));
    });

    test('should throw FirebaseAuthException when sign up fails', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'code', message: 'message'));

      expect(() => dataSource.signUp(email: tEmail, password: tPassword),
          throwsA(isA<FirebaseAuthException>()));
    });
  });

  group('signOut', () {
    test('should sign out', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await dataSource.signOut();

      verify(() => mockFirebaseAuth.signOut());
    });

    test('should throw FirebaseAuthException when sign out fails', () async {
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(FirebaseAuthException(code: 'code', message: 'message'));

      expect(() => dataSource.signOut(), throwsA(isA<FirebaseAuthException>()));
    });
  });
}
