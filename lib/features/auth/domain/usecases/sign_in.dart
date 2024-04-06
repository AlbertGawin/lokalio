import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCase<void, SignInParams> {
  final AuthRepository authRepository;

  const SignIn({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(SignInParams params) async {
    return await authRepository.signIn(credential: params.credential);
  }
}

class SignInParams extends Equatable {
  final AuthCredential credential;

  const SignInParams({required this.credential});

  @override
  List<Object?> get props => [credential];
}
