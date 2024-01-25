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

final class SetProfileInfoEvent extends AuthEvent {
  final String name;
  final String phone;
  final String smsCode;

  const SetProfileInfoEvent({
    required this.name,
    required this.phone,
    required this.smsCode,
  });

  @override
  List<Object> get props => [name, phone, smsCode];
}
