import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/message_type.dart';
import '../../../../core/models/either.dart';
import '../../../../core/models/failure.dart';
import '../../models/message_model.dart';
import '../../repos/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  static const int _pageSize = 20;

  StreamSubscription<Either<Failure, List<MessageModel>>>?
      _messagesSubscription;

  ChatCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatInitialState());

  
  List<MessageModel> _getCurrentMessages() {
    return switch (state) {
      ChatLoadedState(messages: final msgs) => msgs,
      ChatLoadingState(currentMessages: final msgs) => msgs,
      ChatErrorState(currentMessages: final msgs) => msgs,
      ChatInitialState() => const <MessageModel>[],
    };
  }

  
  bool _getHasMore() {
    return switch (state) {
      ChatLoadedState(hasMore: final hasMore) => hasMore,
      ChatLoadingState(currentMessages: final msgs) => msgs.length >= _pageSize,
      ChatErrorState(currentMessages: final msgs) => msgs.length >= _pageSize,
      ChatInitialState() => true,
    };
  }

  void fetchMessages({required String chatId}) {
    emit(const ChatLoadingState());
    _messagesSubscription?.cancel();

    _messagesSubscription = _chatRepository
        .fetchMessages(
      chatId: chatId,
      limit: _pageSize,
    )
        .listen(
      (result) {
        result.fold(
          (failure) {
            emit(
              ChatErrorState(
                failure.message,
                currentMessages: _getCurrentMessages(),
              ),
            );
          },
          (newMessages) {
            final currentMessages = _getCurrentMessages();
            final mergedMessages = {
              ...newMessages,
              ...currentMessages,
            }.toList();
            final hasMore = currentMessages.isNotEmpty
                ? _getHasMore()
                : newMessages.length >= _pageSize;

            emit(ChatLoadedState(
              mergedMessages,
              hasMore: hasMore,
            ));
          },
        );
      },
    );
  }

  void loadMoreMessages({required String chatId}) {
    if (!_getHasMore()) return;
    final currentMessages = _getCurrentMessages();
    final lastMessage =
        currentMessages.isNotEmpty ? currentMessages.last : null;

    emit(ChatLoadingState(
      currentMessages: currentMessages,
      isLoadingMore: true,
    ));

    _chatRepository
        .fetchMessages(
      chatId: chatId,
      limit: _pageSize,
      lastMessage: lastMessage,
    )
        .listen(
      (result) {
        result.fold(
          (failure) {
            emit(ChatErrorState(
              failure.message,
              currentMessages: currentMessages,
            ));
          },
          (newMessages) {
            final updatedMessages = [
              ...currentMessages,
              ...newMessages,
            ];
            emit(ChatLoadedState(
              updatedMessages,
              hasMore: newMessages.length >= _pageSize,
            ));
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
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    final messageModel = MessageModel(
      id: const Uuid().v4(),
      message: message,
      senderId: currentUserId,
      time: DateTime.now().millisecondsSinceEpoch,
      type: MessageType.text,
    );

    
    emit(ChatLoadedState(
      [
        messageModel,
        ...currentState.messages,
      ],
      hasMore: currentState.hasMore,
    ));

    final result = await _chatRepository.sendTextMessage(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      message: messageModel,
    );

    result.fold(
      (failure) {
        emit(ChatErrorState(failure.message,
            currentMessages: currentState.messages));
      },
      (_) {},
    );
  }

  Future<void> sendMediaMessage({
    required String currentUserId,
    required String otherUserId,
    required String message,
    required String mediaPath,
    required MessageType type,
  }) async {
    if (state is! ChatLoadedState) return;
    final currentState = state as ChatLoadedState;

    final messageModel = MessageModel(
      id: const Uuid().v4(),
      message: message,
      senderId: currentUserId,
      time: DateTime.now().millisecondsSinceEpoch,
      type: type,
      mediaUrl: mediaPath,
    );

    
    emit(ChatLoadedState(
      [
        messageModel,
        ...currentState.messages,
      ],
      hasMore: currentState.hasMore,
    ));

    final result = await _chatRepository.sendMediaMessage(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      message: messageModel,
    );

    result.fold(
      (failure) {
        emit(ChatErrorState(failure.message,
            currentMessages: currentState.messages));
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
