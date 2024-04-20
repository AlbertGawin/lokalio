import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../profile/domain/entities/profile.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  late final StreamSubscription<Profile> _profileSubscription;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState.unauthenticated()) {
    on<_AuthUserChanged>(_onUserChanged);
    on<SignOutEvent>(_onLogoutRequested);
    _profileSubscription = _repository.profile.listen(
      (profile) => add(_AuthUserChanged(profile: profile)),
    );
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.profile.isEmpty) {
      emit(const AuthState.unauthenticated());
      return;
    }

    if (event.profile.username.isEmpty ||
        event.profile.email.isEmpty ||
        event.profile.phoneNumber.isEmpty ||
        event.profile.city.isEmpty) {
      emit(const AuthState.missingData());
      return;
    }

    emit(AuthState.authenticated(profile: event.profile));
  }

  void _onLogoutRequested(SignOutEvent event, Emitter<AuthState> emit) {
    unawaited(_repository.signOut());
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
