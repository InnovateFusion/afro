import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/product.dart';

class BackgroundRemoverUseCase extends UseCase<File, BackgroundRemoverParams> {
  final ProductRepository repository;

  BackgroundRemoverUseCase(this.repository);

  @override
  Future<Either<Failure, File>> call(BackgroundRemoverParams params) async {
    return await repository.removeBackground(
        imageFile: params.image, token: params.token);
  }
}

class BackgroundRemoverParams extends Equatable {
  final File image;
  final String token;

  const BackgroundRemoverParams({required this.image, required this.token});

  @override
  List<Object> get props => [image, token];
}
