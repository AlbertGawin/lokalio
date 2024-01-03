import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_up.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;

  AuthBloc({required this.signIn, required this.signUp, required this.signOut})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInEvent) {
        emit(Loading());
        await signIn(SignInParams(email: event.email, password: event.password))
            .then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (_) => emit(Done()),
          );
        });
      } else if (event is SignUpEvent) {
        emit(Loading());
        await signUp(SignUpParams(email: event.email, password: event.password))
            .then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (_) => emit(Done()),
          );
        });
      } else if (event is SignOutEvent) {
        emit(Loading());
        await signOut(NoParams()).then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (_) => emit(Done()),
          );
        });
      }
    });
  }
}
