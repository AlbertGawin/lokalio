import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  late final StreamSubscription<User> _userSubscription;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState.unauthenticated()) {
    on<_AuthUserChanged>(_onUserChanged);
    on<SignOutEvent>(_onLogoutRequested);
    _userSubscription = _repository.user.listen(
      (user) => add(_AuthUserChanged(user: user)),
    );
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      event.user.isNotEmpty
          ? AuthState.authenticated(user: event.user)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(SignOutEvent event, Emitter<AuthState> emit) {
    unawaited(_repository.signOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
