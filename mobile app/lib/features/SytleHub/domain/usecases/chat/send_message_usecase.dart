import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_entity.dart';

class SendMessageUsecase extends UseCase<ChatEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUsecase(this.repository);

  @override
  Future<Either<Failure, ChatEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      token: params.token,
      receiverId: params.receiverId,
      message: params.message,
      type: params.type,
    );
  }
}

class SendMessageParams extends Equatable {
  final String token;
  final String receiverId;
  final String message;
  final int type;

  const SendMessageParams({
    required this.token,
    required this.receiverId,
    required this.message,
    required this.type,
  });

  @override
  List<Object> get props => [token, receiverId, message, type];
}
