import 'package:chat/core/extensions/extensions.dart';
import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';

import '../../../core/data_sources/storage/storage_data_source.dart';
import '../../../core/supabase/supabase_constants.dart';
import '../data_sources/chat_data_source.dart';
import '../models/message_model.dart';
import 'chat_repository.dart';

class FirebaseChatRepository implements ChatRepository {
  final ChatDataSource _chatDataSource;
  final StorageDataSource _storageDataSource;

  FirebaseChatRepository({
    required ChatDataSource chatDataSource,
    required StorageDataSource storageDataSource,
  })  : _chatDataSource = chatDataSource,
        _storageDataSource = storageDataSource;

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

  @override
  Future<Either<Failure, Unit>> sendImageMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  }) async {
    final uploadResult = await _storageDataSource.uploadFile(
      filePath: message.message,
      fileName:
          "${[currentUserId, otherUserId].generateChatId()}/${message.id}",
      bucketName: SupabaseConstants.messagesBucket,
    );
    return uploadResult.fold(
      (failure) => Either.left(failure),
      (url) {
        final messageWithUrl =
            message.copyWith(message: url, type: MessageType.image);
        return _chatDataSource.sendMessage(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
          message: messageWithUrl,
        );
      },
    );
  }
}
