import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_participant_entity.dart';

class GetChatParticipantsUsecase
    extends UseCase<List<ChatParticipantEntity>, GetChatParticipantsParams> {
  final ChatRepository repository;

  GetChatParticipantsUsecase(this.repository);

  @override
  Future<Either<Failure, List<ChatParticipantEntity>>> call(
      GetChatParticipantsParams params) async {
    return await repository.getChatParticipants(
        token: params.token, limit: params.limit, skip: params.skip);
  }
}

class GetChatParticipantsParams extends Equatable {
  final String token;
  final int limit;
  final int skip;

  const GetChatParticipantsParams({
    required this.token,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object> get props => [token, limit, skip];
}
