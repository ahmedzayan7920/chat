import '../../models/chat_model.dart';

sealed class ChatsState {
  const ChatsState();
}

class ChatsInitialState extends ChatsState {
  const ChatsInitialState();
}

class ChatsLoadingState extends ChatsState {
  const ChatsLoadingState();
}

class ChatsLoadedState extends ChatsState {
  final List<ChatModel> chats;

  const ChatsLoadedState(this.chats);
}

class ChatsErrorState extends ChatsState {
  final String message;

  const ChatsErrorState(this.message);
}
