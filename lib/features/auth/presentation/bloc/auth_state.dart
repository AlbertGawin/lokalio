part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  missingData,
}

final class AuthState extends Equatable {
  final AuthStatus status;
  final Profile profile;

  const AuthState._({
    required this.status,
    this.profile = Profile.empty,
  });

  const AuthState.authenticated({required Profile profile})
      : this._(status: AuthStatus.authenticated, profile: profile);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.missingData() : this._(status: AuthStatus.missingData);

  @override
  List<Object> get props => [status, profile];
}
