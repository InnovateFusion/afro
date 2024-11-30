import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_user_with_last_message_entity.dart';

class GetChatParticipantsWithLastMessageUsecase extends UseCase<
    List<ChatUserWithLastMessageEntity>,
    GetChatParticipantsWithLastMessageParams> {
  final ChatRepository repository;

  GetChatParticipantsWithLastMessageUsecase(this.repository);

  @override
  Future<Either<Failure, List<ChatUserWithLastMessageEntity>>> call(
      GetChatParticipantsWithLastMessageParams params) async {
    return await repository.getChatParticipantsWithLastMessage(
        token: params.token, limit: params.limit, skip: params.skip);
  }
}

class GetChatParticipantsWithLastMessageParams extends Equatable {
  final String token;
  final int limit;
  final int skip;

  const GetChatParticipantsWithLastMessageParams({
    required this.token,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object> get props => [token, limit, skip];
}
