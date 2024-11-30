import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/product.dart';

class BackgroundRemoverFromUrlUseCase extends UseCase<File, BackgroundRemoverParams> {
  final ProductRepository repository;

 BackgroundRemoverFromUrlUseCase(this.repository);

  @override
  Future<Either<Failure, File>> call(BackgroundRemoverParams params) async {
    return await repository.removeBackgroundFromUrl(
        imageUrl: params.imageUrl, token: params.token);
  }
}

class BackgroundRemoverParams extends Equatable {
  final String imageUrl;
  final String token;

  const BackgroundRemoverParams({required this.imageUrl, required this.token});

  @override
  List<Object> get props => [imageUrl, token];
}
