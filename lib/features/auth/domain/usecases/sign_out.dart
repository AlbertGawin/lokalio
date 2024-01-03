import 'package:dartz/dartz.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository authRepository;

  const SignOut({required this.authRepository});

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
