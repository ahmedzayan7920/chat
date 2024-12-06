import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';

import '../data_sources/chat_data_source.dart';
import '../models/message_model.dart';
import 'chat_repository.dart';

class FirebaseChatRepository implements ChatRepository {
  final ChatDataSource _chatDataSource;

  FirebaseChatRepository({
    required ChatDataSource chatDataSource,
  }) : _chatDataSource = chatDataSource;

  @override
  Stream<Either<Failure, List<MessageModel>>> fetchMessages({
    required String chatId,
  }) async* {
    yield* _chatDataSource.fetchMessages(chatId: chatId);
  }

  @override
  Future<Either<Failure, Unit>> sendTextMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  }) async {
    return _chatDataSource.sendMessage(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      message: message,
    );
  }
}
