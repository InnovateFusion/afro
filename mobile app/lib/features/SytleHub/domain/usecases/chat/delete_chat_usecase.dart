import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_entity.dart';

class DeleteChatUsecase extends UseCase<ChatEntity, DeleteChatParams> {
  final ChatRepository repository;

  DeleteChatUsecase(this.repository);

  @override
  Future<Either<Failure, ChatEntity>> call(DeleteChatParams params) async {
    return await repository.deleteChat(token: params.token, chatId: params.id);
  }
}

class DeleteChatParams extends Equatable {
  final String token;
  final String id;

  const DeleteChatParams({
    required this.token,
    required this.id,
  });

  @override
  List<Object> get props => [token, id];
}
