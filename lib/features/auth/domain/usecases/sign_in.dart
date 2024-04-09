import 'package:equatable/equatable.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCase<void, SignInParams> {
  final AuthRepository authRepository;

  const SignIn({required this.authRepository});

  @override
  Future<void> call(SignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
