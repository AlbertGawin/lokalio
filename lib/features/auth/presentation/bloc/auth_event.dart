part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class SignInEvent extends AuthEvent {
  final AuthCredential credential;

  const SignInEvent({required this.credential});

  @override
  List<Object> get props => [credential];
}

final class SignInAnonymouslyEvent extends AuthEvent {
  const SignInAnonymouslyEvent();
}

final class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}
