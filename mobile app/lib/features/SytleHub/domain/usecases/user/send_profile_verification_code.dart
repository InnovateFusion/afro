import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class SendProfileVerificationCodeUseCase extends UseCase<String, Params> {
  final UserRepository repository;

  SendProfileVerificationCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.sendProfileVerificationCode(
      email: params.email,
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String email;
  final String token;

  const Params({
    required this.email,
    required this.token,
  });

  @override
  List<Object> get props => [email, token];
}
