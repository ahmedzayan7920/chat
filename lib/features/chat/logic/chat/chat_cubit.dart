import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/either.dart';
import '../../../../core/models/failure.dart';
import '../../models/message_model.dart';
import '../../repos/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  StreamSubscription<Either<Failure, List<MessageModel>>>?
      _messagesSubscription;

  ChatCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatInitialState());

  void fetchMessages({required String chatId}) {
    emit(const ChatLoadingState());

    _messagesSubscription?.cancel();

    _messagesSubscription =
        _chatRepository.fetchMessages(chatId: chatId).listen(
      (result) {
        result.fold(
          (failure) {
            emit(ChatErrorState(failure.message));
          },
          (messages) {
            emit(ChatLoadedState(messages));
          },
        );
      },
    );
  }

  Future<void> sendTextMessage({
    required String currentUserId,
    required String otherUserId,
    required String message,
  }) async {
    final messageModel = MessageModel(
      id: const Uuid().v4(),
      message: message,
      senderId: currentUserId,
      time: DateTime.now().millisecondsSinceEpoch,
      type: MessageType.text,
    );
    final result = await _chatRepository.sendTextMessage(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      message: messageModel,
    );

    result.fold(
      (failure) {
        emit(ChatErrorState(failure.message));
      },
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
