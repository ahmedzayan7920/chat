import '../../models/chat_model.dart';

sealed class ChatsState {
  const ChatsState();
}

class ChatsInitialState extends ChatsState {
  const ChatsInitialState();
}

class ChatsLoadingState extends ChatsState {
  final List<ChatModel> currentChats;
  final bool isLoadingMore;
  const ChatsLoadingState({
    this.currentChats = const [],
    this.isLoadingMore = false,
  });
}

class ChatsLoadedState extends ChatsState {
  final List<ChatModel> chats;
  final bool hasMore;

  const ChatsLoadedState({required this.chats, this.hasMore = true});
}

class ChatsErrorState extends ChatsState {
  final String message;
  final List<ChatModel> currentChats;

  const ChatsErrorState({required this.message, this.currentChats = const []});
}
