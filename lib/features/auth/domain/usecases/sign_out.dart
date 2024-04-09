import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  const SignOut({required this.authRepository});

  @override
  Future<void> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
