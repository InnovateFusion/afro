import 'package:either_dart/either.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../repositories/auth.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository userRepository;

  SignOutUseCase(this.userRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await userRepository.signOut();
  }
}
