import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/either.dart';
import '../../../../core/models/failure.dart';
import '../../models/chat_model.dart';
import '../../repos/chats_repository.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _chatsRepository;

  ChatsCubit({required ChatsRepository chatsRepository})
      : _chatsRepository = chatsRepository,
        super(const ChatsInitialState());

  static const int _pageSize = 20;

  StreamSubscription<Either<Failure, List<ChatModel>>>? _chatsSubscription;

  List<ChatModel> _getCurrentChats() {
    return switch (state) {
      ChatsLoadedState(chats: final chats) => chats,
      ChatsLoadingState(currentChats: final chats) => chats,
      ChatsErrorState(currentChats: final chats) => chats,
      ChatsInitialState() => const <ChatModel>[],
    };
  }

  bool _getHasMore() {
    return switch (state) {
      ChatsLoadedState(hasMore: final hasMore) => hasMore,
      ChatsLoadingState(currentChats: final chats) => chats.length >= _pageSize,
      ChatsErrorState(currentChats: final chats) => chats.length >= _pageSize,
      ChatsInitialState() => true,
    };
  }

  void fetchChats({required String currentUserId}) {
    emit(const ChatsLoadingState());
    _chatsSubscription?.cancel();

    _chatsSubscription = _chatsRepository
        .fetchChats(
      currentUserId: currentUserId,
      limit: _pageSize,
    )
        .listen(
      (result) {
        result.fold(
          (failure) {
            emit(
              ChatsErrorState(
                message: failure.message,
                currentChats: _getCurrentChats(),
              ),
            );
          },
          (newChats) {
            var currentChats = List<ChatModel>.from(_getCurrentChats());
            currentChats.removeWhere((chat) {
              return newChats.any((e) {
                return e.id == chat.id;
              });
            });
            final mergedChats = [
              ...newChats,
              ...currentChats,
            ];
            final hasMore = currentChats.isNotEmpty
                ? _getHasMore()
                : newChats.length >= _pageSize;

            emit(ChatsLoadedState(
              chats: mergedChats,
              hasMore: hasMore,
            ));
          },
        );
      },
    );
  }

  void loadMoreChats({required String currentUserId}) {
    if (!_getHasMore()) return;
    var currentChats = List<ChatModel>.from(_getCurrentChats());
    final lastChat = currentChats.isNotEmpty ? currentChats.last : null;

    emit(ChatsLoadingState(
      currentChats: currentChats,
      isLoadingMore: true,
    ));

    _chatsRepository
        .fetchChats(
      currentUserId: currentUserId,
      limit: _pageSize,
      lastChat: lastChat,
    )
        .listen(
      (result) {
        result.fold(
          (failure) {
            emit(ChatsErrorState(
              message: failure.message,
              currentChats: currentChats,
            ));
          },
          (newChats) {
            currentChats.removeWhere((chat) {
              return newChats.any((e) {
                return e.id == chat.id;
              });
            });
            final updatedChats = [
              ...currentChats,
              ...newChats,
            ];
            emit(ChatsLoadedState(
              chats: updatedChats,
              hasMore: newChats.length >= _pageSize,
            ));
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
