import '../../models/message_model.dart';

sealed class ChatState {
  const ChatState();
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

class ChatLoadedState extends ChatState {
  final List<MessageModel> messages;

  const ChatLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState(this.message);
}
