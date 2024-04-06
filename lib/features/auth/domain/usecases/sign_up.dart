import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignUp implements UseCase<void, SignUpParams> {
  final AuthRepository authRepository;

  const SignUp({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await authRepository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;

  const SignUpParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
