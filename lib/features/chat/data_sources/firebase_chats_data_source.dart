import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';
import 'package:chat/core/utils/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/user_model.dart';
import '../../../core/utils/app_strings.dart';
import '../models/chat_model.dart';
import 'chats_data_source.dart';

class FirebaseChatsDataSource implements ChatsDataSource {
  final FirebaseFirestore _firestore;

  FirebaseChatsDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
Stream<Either<Failure, List<ChatModel>>> fetchChats({
  required String currentUserId,
}) async* {
  try {
    final chatStream = _firestore
        .collection(FirebaseConstants.chats)
        .where(ChatModelKeys.members, arrayContains: currentUserId)
        .orderBy(ChatModelKeys.lastMessageTime, descending: true)
        .snapshots();

    await for (final snapshot in chatStream) {
      if (snapshot.docs.isEmpty) {
        yield Either.right([]);
      } else {
        final chatModels = snapshot.docs.map((doc) {
          return ChatModel.fromJson(doc.data());
        }).toList();

        final userIds = _extractUserIds(chatModels, currentUserId);
        final userMap = await _fetchUserDetails(userIds);

        final chats = chatModels.map((chat) {
          final otherUserId = chat.members.firstWhere(
            (id) => id != currentUserId,
            orElse: () => currentUserId,
          );
          final userDetails = userMap[otherUserId];
          return chat.copyWith(
            userName:
                userDetails?[UserModelKeys.name] ?? AppStrings.emptyString,
            userProfilePictureUrl:
                userDetails?[UserModelKeys.profilePictureUrl] ??
                    AppStrings.emptyString,
          );
        }).toList();

        yield Either.right(chats);
      }
    }
  } catch (e) {
    yield Either.left(Failure.fromException(e));
  }
}


  List<String> _extractUserIds(List<ChatModel> chats, String currentUserId) {
    return chats
        .map(
          (chat) => chat.members.firstWhere(
            (id) => id != currentUserId,
            orElse: () => currentUserId,
          ),
        )
        .toSet()
        .toList();
  }

  Future<Map<String, Map<String, dynamic>>> _fetchUserDetails(
      List<String> userIds) async {
    final userMap = <String, Map<String, dynamic>>{};

    const int chunkSize = 10;
    final chunks = List.generate(
      (userIds.length / chunkSize).ceil(),
      (i) => userIds.skip(i * chunkSize).take(chunkSize).toList(),
    );

    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection(FirebaseConstants.users)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in snapshot.docs) {
        userMap[doc.id] = doc.data();
      }
    }
    return userMap;
  }
}
