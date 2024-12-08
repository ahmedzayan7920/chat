import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';

import '../models/chat_model.dart';

abstract class ChatsRepository {
  Stream<Either<Failure, List<ChatModel>>> fetchChats({
    required String currentUserId,
  });
}
