import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';

import '../models/message_model.dart';

abstract class ChatDataSource {
  Stream<Either<Failure, List<MessageModel>>> fetchMessages({
    required String chatId,
  });

  Future<Either<Failure, Unit>> sendMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  });
}
