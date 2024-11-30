import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/real_time_chat_entity.dart';

class RealtimeChatResponseUsecase
    extends UseCase<RealTimeChatEntity, RealtimeChatResponseParams> {
  final ChatRepository repository;

  RealtimeChatResponseUsecase(this.repository);

  @override
  Future<Either<Failure, RealTimeChatEntity>> call(
      RealtimeChatResponseParams params) async {
    return await repository.realTimeChatResponse(
      message: params.message,
    );
  }
}

class RealtimeChatResponseParams extends Equatable {
  final String message;

  const RealtimeChatResponseParams({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
