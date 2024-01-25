import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/usecases/set_profile_info.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_up.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final SetProfileInfo setProfileInfo;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.setProfileInfo,
  }) : super(Done()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInEvent) {
        emit(Loading());
        await signIn(SignInParams(credential: event.credential))
            .then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failure.message)),
            (_) => emit(Done()),
          );
        });
      } else if (event is SignUpEvent) {
        emit(Loading());
        await signUp(SignUpParams(email: event.email, password: event.password))
            .then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failure.message)),
            (_) => emit(Done()),
          );
        });
      } else if (event is SignOutEvent) {
        emit(Loading());
        await signOut(NoParams()).then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failure.message)),
            (_) => emit(Done()),
          );
        });
      } else if (event is SetProfileInfoEvent) {
        emit(Loading());
        await setProfileInfo(ProfileParams(
          name: event.name,
          phone: event.phone,
          smsCode: event.smsCode,
        )).then((failure) {
          failure.fold(
            (failure) => emit(Error(message: failure.message)),
            (_) => emit(Done()),
          );
        });
      }
    });
  }
}
