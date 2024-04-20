part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

final class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged({required this.profile});

  final Profile profile;
}
