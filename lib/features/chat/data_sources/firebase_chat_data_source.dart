import '../../../core/extensions/extensions.dart';
import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/utils/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_data_source.dart';

class FirebaseChatDataSource implements ChatDataSource {
  final FirebaseFirestore _firestore;

  FirebaseChatDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Stream<Either<Failure, List<MessageModel>>> fetchMessages({
    required String chatId,
  }) async* {
    try {
      final messageStream = _firestore
          .collection(FirebaseConstants.chats)
          .doc(chatId)
          .collection(FirebaseConstants.messages)
          .orderBy(MessageModelKeys.time, descending: false)
          .snapshots();

      await for (final snapshot in messageStream) {
        final messages = snapshot.docs.map((doc) {
          return MessageModel.fromJson(doc.data());
        }).toList();

        yield Either.right(messages);
      }
    } catch (e) {
      yield Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String currentUserId,
    required String otherUserId,
    required MessageModel message,
  }) async {
    try {
      final chatId = [currentUserId, otherUserId].generateChatId();
      final chatDoc =
          _firestore.collection(FirebaseConstants.chats).doc(chatId);

      final chatSnapshot = await chatDoc.get();
      if (!chatSnapshot.exists) {
        final newChat = ChatModel(
          id: chatId,
          members: [currentUserId, otherUserId],
          lastMessageModel: LastMessageModel(
            lastMessage: message.message,
            lastMessageTime: message.time,
            type: message.type,
            isSeen: false,
          ),
        );
        await chatDoc.set(newChat.toJson());
      } else {
        await chatDoc.update({
          ChatModelKeys.lastMessageModel: LastMessageModel(
            lastMessage: message.message,
            lastMessageTime: message.time,
            type: message.type,
            isSeen: false,
          ).toJson(),
        });
      }

      final messageDoc =
          chatDoc.collection(FirebaseConstants.messages).doc(message.id);
      await messageDoc.set(message.toJson());

      return Either.right(const Unit());
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
