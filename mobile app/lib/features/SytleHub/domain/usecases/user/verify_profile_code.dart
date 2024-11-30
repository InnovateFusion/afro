import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../../data/models/user/email_verify_model.dart';
import '../../repositories/user.dart';

class VerifyProfileCodeUseCase extends UseCase<EmailVerifyModel, Params> {
  final UserRepository repository;

  VerifyProfileCodeUseCase(this.repository);

  @override
  Future<Either<Failure, EmailVerifyModel>> call(Params params) async {
    return await repository.verifyProfileCode(
      email: params.email,
      code: params.code,
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String email;
  final String code;
  final String token;

  const Params({
    required this.email,
    required this.code,
    required this.token,
  });

  @override
  List<Object> get props => [email, code, token];
}
