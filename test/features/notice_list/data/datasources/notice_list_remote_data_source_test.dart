// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQueryMapSnapshot extends Mock
    implements Query<Map<String, dynamic>> {}

void main() {
  setupFirebaseAuthMocks();

  late NoticeListRemoteDataSourceImpl noticeListRemoteDataSourceImpl;
  late MockFirestore mockFirestoreFirebase;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockQueryMapSnapshot mockQueryMapSnapshot;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockFirestoreFirebase = MockFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    noticeListRemoteDataSourceImpl = NoticeListRemoteDataSourceImpl(
      firebaseFirestore: mockFirestoreFirebase,
      firebaseAuth: mockFirebaseAuth,
    );
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockCollectionReference = MockCollectionReference();
    mockQueryMapSnapshot = MockQueryMapSnapshot();
    mockUser = MockUser();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  void setUpMockFirebaseSuccess200() {
    when(() => mockQueryDocumentSnapshot.data())
        .thenReturn({'id': '1', 'title': 'title'});
    when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(() => mockFirestoreFirebase.collection(any()))
        .thenReturn(mockCollectionReference);
    when(() => mockQueryMapSnapshot.get())
        .thenAnswer((_) async => mockQuerySnapshot);
    when(() => mockCollectionReference.where(any(),
            isNotEqualTo: any(named: 'isNotEqualTo')))
        .thenReturn(mockQueryMapSnapshot);

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('1');
  }

  void setUpMockFirebaseSuccess404() {
    when(() => mockFirebaseAuth.currentUser).thenReturn(null);
  }

  group('getAllNotices', () {
    final tNoticeList = [const NoticeModel(id: '1', title: 'title')];

    test('should perform and GET request on a Firebase collection', () {
      setUpMockFirebaseSuccess200();

      noticeListRemoteDataSourceImpl.getAllNotices();

      verify(() => mockFirestoreFirebase.collection('notices').get());
    });

    test('should return a list of NoticeModel when the response code is 200',
        () async {
      setUpMockFirebaseSuccess200();

      final result = await noticeListRemoteDataSourceImpl.getAllNotices();

      expect(result, equals(tNoticeList));
    });

    test('should throw a FirebaseAuthException when the user is not found',
        () async {
      setUpMockFirebaseSuccess404();

      final call = noticeListRemoteDataSourceImpl.getAllNotices;

      expect(() => call(), throwsA(const TypeMatcher<FirebaseAuthException>()));
    });
  });
}
