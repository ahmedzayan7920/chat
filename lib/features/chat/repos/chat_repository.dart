import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';

import '../models/message_model.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<MessageModel>>> fetchMessages({
    required String chatId,
  });
  Future<Either<Failure, Unit>> sendTextMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  });

  Future<Either<Failure, Unit>> sendMediaMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  });
}
