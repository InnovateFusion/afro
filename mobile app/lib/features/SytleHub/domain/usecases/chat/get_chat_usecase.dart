import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_entity.dart';

class GetChatUsecase extends UseCase<ChatEntity, GetChatParams> {
  final ChatRepository repository;

  GetChatUsecase(this.repository);

  @override
  Future<Either<Failure, ChatEntity>> call(GetChatParams params) async {
    return await repository.getChat(token: params.token, chatId: params.id);
  }
}

class GetChatParams extends Equatable {
  final String token;
  final String id;

  const GetChatParams({
    required this.token,
    required this.id,
  });

  @override
  List<Object> get props => [token, id];
}
