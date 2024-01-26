import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/usecases/set_profile_info.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_out.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_up.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockSignOut extends Mock implements SignOut {}

class MockSetProfileInfo extends Mock implements SetProfileInfo {}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late AuthBloc bloc;

  late MockSignIn mockSignIn;
  late MockSignUp mockSignUp;
  late MockSignOut mockSignOut;
  late MockSetProfileInfo mockSetProfileInfo;

  late MockAuthCredential mockAuthCredential;

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignUp = MockSignUp();
    mockSignOut = MockSignOut();
    mockSetProfileInfo = MockSetProfileInfo();

    bloc = AuthBloc(
      signIn: mockSignIn,
      signUp: mockSignUp,
      signOut: mockSignOut,
      setProfileInfo: mockSetProfileInfo,
    );
  });

  const tEmail = 'test@mail.com';
  const tPassword = 'password';
  setUpAll(() {
    mockAuthCredential = MockAuthCredential();
    registerFallbackValue(SignInParams(credential: mockAuthCredential));
    registerFallbackValue(
        const SignUpParams(email: tEmail, password: tPassword));
    registerFallbackValue(NoParams());
  });

  test('initialState should be Done', () {
    expect(bloc.state, equals(Done()));
  });

  group('SignIn', () {
    test('should get data from the SignIn use case', () async {
      when(() => mockSignIn(any())).thenAnswer((_) async => const Right(null));

      bloc.add(SignInEvent(credential: mockAuthCredential));
      await untilCalled(() => mockSignIn(any()));

      verify(() => mockSignIn(SignInParams(credential: mockAuthCredential)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      when(() => mockSignIn(any())).thenAnswer((_) async => const Right(null));

      final expected = [Loading(), Done()];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(SignInEvent(credential: mockAuthCredential));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockSignIn(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(SignInEvent(credential: mockAuthCredential));
    });
  });

  group('SignUp', () {
    test('should get data from the SignUp use case', () async {
      when(() => mockSignUp(any())).thenAnswer((_) async => const Right(null));

      bloc.add(const SignUpEvent(email: tEmail, password: tPassword));
      await untilCalled(() => mockSignUp(any()));

      verify(() =>
          mockSignUp(const SignUpParams(email: tEmail, password: tPassword)));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      when(() => mockSignUp(any())).thenAnswer((_) async => const Right(true));

      final expected = [Loading(), Done()];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const SignUpEvent(email: tEmail, password: tPassword));
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockSignUp(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const SignUpEvent(email: tEmail, password: tPassword));
    });
  });

  group('SignOut', () {
    test('should get data from the SignOut use case', () async {
      when(() => mockSignOut(any())).thenAnswer((_) async => const Right(true));

      bloc.add(const SignOutEvent());
      await untilCalled(() => mockSignOut(any()));

      verify(() => mockSignOut(NoParams()));
    });

    test(
        'should emit [Loading, Done] when data is gotten successfully from the use case',
        () async {
      when(() => mockSignOut(any())).thenAnswer((_) async => const Right(true));

      final expected = [Loading(), Done()];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const SignOutEvent());
    });

    test(
        'should emit [Loading, Error] when getting data fails from the use case',
        () async {
      when(() => mockSignOut(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: failureMessages[FailureType.serverFailure]!),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const SignOutEvent());
    });
  });
}
