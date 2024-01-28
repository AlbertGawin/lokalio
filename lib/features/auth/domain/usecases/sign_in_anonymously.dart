import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignInAnonymously implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  const SignInAnonymously({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signInAnonymously();
  }
}
