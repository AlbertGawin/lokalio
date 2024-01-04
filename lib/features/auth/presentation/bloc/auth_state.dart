part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Loading extends AuthState {}

final class Done extends AuthState {}

final class Authenticated extends AuthState {}

final class Error extends AuthState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
