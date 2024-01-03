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
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = AuthRemoteDataSourceImpl(firebaseAuth: mockFirebaseAuth);

    mockUserCredential = MockUserCredential();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  void setUp200() {
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.get())
        .thenAnswer((_) => Future.value(mockQueryDocumentSnapshot));
    when(() => mockQueryDocumentSnapshot.exists).thenReturn(true);
  }

  group('signIn', () {
    const tEmail = 'test';
    const tPassword = 'test';

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
}
