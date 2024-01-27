// ignore_for_file: subtype_of_sealed_class

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../mock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

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

  late MockFirestore mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  late MockQuerySnapshot mockQuerySnapshot;
  late MockCollectionReference mockCollectionReference;
  late MockQueryMapSnapshot mockQueryMapSnapshot;

  setUp(() {
    mockFirestore = MockFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    noticeListRemoteDataSourceImpl = NoticeListRemoteDataSourceImpl(
      firebaseFirestore: mockFirestore,
      firebaseAuth: mockFirebaseAuth,
    );
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    mockQuerySnapshot = MockQuerySnapshot();
    mockCollectionReference = MockCollectionReference();
    mockQueryMapSnapshot = MockQueryMapSnapshot();
  });

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  void setUp200() {
    when(() => mockFirestore.collection(any()))
        .thenReturn(mockCollectionReference);
    when(() => mockQueryMapSnapshot.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));
  }

  void setUpAllNotices() {
    when(() => mockCollectionReference.where(any(),
            isNotEqualTo: any(named: 'isNotEqualTo')))
        .thenReturn(mockQueryMapSnapshot);
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('1');
  }

  void setUpMyNotices() {
    when(() => mockCollectionReference.where(any(),
        isEqualTo: any(named: 'isEqualTo'))).thenReturn(mockQueryMapSnapshot);
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('1');
  }

  void setUpUserNotices() {
    when(() => mockCollectionReference.where(any(),
        isEqualTo: any(named: 'isEqualTo'))).thenReturn(mockQueryMapSnapshot);
  }

  group('getAllNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId != '1')
        .toList();

    final tQueryDocumentSnapshotList = tNoticeModelList.map((noticeModel) {
      final mockDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockDocSnapshot.data()).thenReturn(noticeModel.toJson());
      return mockDocSnapshot;
    }).toList();

    test('should perform and GET request on a Firebase collection', () async {
      setUp200();
      setUpAllNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] != '1')
          .toList());

      await noticeListRemoteDataSourceImpl.getAllNotices();

      verify(() => mockFirestore.collection('notice').get());
    });

    test('should return a list of NoticeModel when the response code is 200',
        () async {
      setUp200();
      setUpAllNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] != '1')
          .toList());

      final result = await noticeListRemoteDataSourceImpl.getAllNotices();

      expect(result, equals(tNoticeModelList));
    });

    test('should return empty list when there are no documents', () async {
      setUp200();
      setUpAllNotices();

      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await noticeListRemoteDataSourceImpl.getAllNotices();

      expect(result, equals([]));
    });

    test('should throw a FirebaseAuthException when the user is not found',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final call = noticeListRemoteDataSourceImpl.getAllNotices;

      expect(() => call(), throwsA(isA<FirebaseAuthException>()));
    });
  });

  group('getMyNotices', () {
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId == '1')
        .toList();

    final tQueryDocumentSnapshotList = tNoticeModelList.map((noticeModel) {
      final mockDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockDocSnapshot.data()).thenReturn(noticeModel.toJson());
      return mockDocSnapshot;
    }).toList();

    test('should perform and GET request on a Firebase collection', () async {
      setUp200();
      setUpMyNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] == '1')
          .toList());

      await noticeListRemoteDataSourceImpl.getMyNotices();

      verify(() => mockFirestore.collection('notice').get());
    });

    test('should return a list of NoticeModel when the response code is 200',
        () async {
      setUp200();
      setUpMyNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] == '1')
          .toList());

      final result = await noticeListRemoteDataSourceImpl.getMyNotices();

      expect(result, equals(tNoticeModelList));
    });

    test('should return empty list when there are no documents', () async {
      setUp200();
      setUpMyNotices();

      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await noticeListRemoteDataSourceImpl.getMyNotices();

      expect(result, equals([]));
    });

    test('should throw a FirebaseAuthException when the user is not found',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final call = noticeListRemoteDataSourceImpl.getMyNotices;

      expect(() => call(), throwsA(isA<FirebaseAuthException>()));
    });
  });

  group('getUserNotices', () {
    const tUserId = '3';
    final tNoticeModelList = List<NoticeModel>.from(json
            .decode(fixture(name: 'notice_list.json'))
            .map<NoticeModel>((e) => NoticeModel.fromJson(json: e)))
        .where((element) => element.userId == tUserId)
        .toList();

    final tQueryDocumentSnapshotList = tNoticeModelList.map((noticeModel) {
      final mockDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockDocSnapshot.data()).thenReturn(noticeModel.toJson());
      return mockDocSnapshot;
    }).toList();

    test('should perform and GET request on a Firebase collection', () {
      setUp200();
      setUpUserNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] == tUserId)
          .toList());

      noticeListRemoteDataSourceImpl.getUserNotices(userId: tUserId);

      verify(() => mockFirestore.collection('notice').get());
    });

    test('should return a list of NoticeModel when the response code is 200',
        () async {
      setUp200();
      setUpUserNotices();

      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshotList
          .where((element) => element.data()['userId'] == tUserId)
          .toList());

      final result =
          await noticeListRemoteDataSourceImpl.getUserNotices(userId: tUserId);

      expect(result, equals(tNoticeModelList));
    });

    test('should return empty list when there are no documents', () async {
      setUp200();
      setUpUserNotices();

      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result =
          await noticeListRemoteDataSourceImpl.getUserNotices(userId: tUserId);

      expect(result, equals([]));
    });
  });
}
