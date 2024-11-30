import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class MakeContactUseCase extends UseCase<String, Params> {
  final ShopRepository repository;

  MakeContactUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.makeContact(
      id: params.id,
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String id;
  final String token;

  const Params({
    required this.id,
    required this.token,
  });

  @override
  List<Object> get props => [id];
}
