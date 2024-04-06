import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:lokalio/features/profile/domain/usecases/read_profile.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockReadProfile extends Mock implements ReadProfile {}

void main() {
  late ProfileBloc bloc;
  late MockReadProfile mockReadProfile;

  setUp(() {
    mockReadProfile = MockReadProfile();

    bloc = ProfileBloc(readProfile: mockReadProfile);
  });

  const tuserId = '1';
  setUpAll(() {
    registerFallbackValue(const Params(userId: tuserId));
    registerFallbackValue(NoParams());
  });

  test('initialState should be ProfileInitial', () {
    expect(bloc.state, equals(ProfileInitial()));
  });

  final tProfile = ProfileModel.fromJson(
    json: json.decode(fixture(name: 'profile.json')),
  );

  group('ReadProfile', () {
    void setUpMockReadProfileSuccess() {
      when(() => mockReadProfile(any()))
          .thenAnswer((_) async => Right(tProfile));
    }

    test('should get data from the ReadProfile usecase', () async {
      setUpMockReadProfileSuccess();

      bloc.add(const ReadProfileEvent(userId: tuserId));
      await untilCalled(() => mockReadProfile(any()));

      verify(() => mockReadProfile(const Params(userId: tuserId)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the usecase',
        () async {
      setUpMockReadProfileSuccess();

      final expected = [Loading(), Done(profile: tProfile)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const ReadProfileEvent(userId: tuserId));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the usecase',
        () async {
      when(() => mockReadProfile(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const ReadProfileEvent(userId: tuserId));
    });
  });
}
