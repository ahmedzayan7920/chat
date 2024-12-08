import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';

import '../data_sources/chats_data_source.dart';
import '../models/chat_model.dart';
import 'chats_repository.dart';

class FirebaseChatsRepository implements ChatsRepository {
  final ChatsDataSource _chatsDataSource;

  FirebaseChatsRepository({
    required ChatsDataSource chatsDataSource,
  }) : _chatsDataSource = chatsDataSource;

  @override
Stream<Either<Failure, List<ChatModel>>> fetchChats({
  required String currentUserId,
}) {
  return _chatsDataSource.fetchChats(currentUserId: currentUserId);
}
}
