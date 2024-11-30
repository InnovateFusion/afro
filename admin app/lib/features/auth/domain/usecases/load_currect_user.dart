import 'package:either_dart/either.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth.dart';

class LoadCurrectUserUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository userRepository;

  LoadCurrectUserUseCase(this.userRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.getCurrentUser();
  }
}
