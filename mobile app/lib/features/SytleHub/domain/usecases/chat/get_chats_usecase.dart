import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/chat/chat_entity.dart';

class GetChatsUsecase extends UseCase<List<ChatEntity>, GetChatsParams> {
  final ChatRepository repository;

  GetChatsUsecase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(GetChatsParams params) async {
    return await repository.getChats(
      token: params.token,
      receiverId: params.receiverId,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetChatsParams extends Equatable {
  final String token;
  final String receiverId;
  final int skip;
  final int limit;

  const GetChatsParams({
    required this.token,
    required this.receiverId,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object> get props => [token, receiverId, skip, limit];
}
