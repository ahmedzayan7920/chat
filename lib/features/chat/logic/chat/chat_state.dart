import '../../models/message_model.dart';

sealed class ChatState {
  const ChatState();
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  final List<MessageModel> currentMessages;
  final bool isLoadingMore;

  const ChatLoadingState({
    this.currentMessages = const [],
    this.isLoadingMore = false,
  });
}

class ChatLoadedState extends ChatState {
  final List<MessageModel> messages;
  final bool hasMore;

  const ChatLoadedState(this.messages, {this.hasMore = true});
}

class ChatErrorState extends ChatState {
  final String message;
  final List<MessageModel> currentMessages;

  const ChatErrorState(this.message, {this.currentMessages = const []});
}
