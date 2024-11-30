import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/chat.dart';

class MarkChatAsReadUsecase extends UseCase<void, MarkChatAsReadParams> {
  final ChatRepository repository;

  MarkChatAsReadUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkChatAsReadParams params) async {
    return await repository.markChatAsRead(
        token: params.token, senderId: params.senderId, chatId: params.chatId);
  }
}

class MarkChatAsReadParams extends Equatable {
  final String token;
  final String senderId;
  final String chatId;

  const MarkChatAsReadParams({
    required this.token,
    required this.senderId,
    required this.chatId,
  });

  @override
  List<Object> get props => [token, senderId, chatId];
}
