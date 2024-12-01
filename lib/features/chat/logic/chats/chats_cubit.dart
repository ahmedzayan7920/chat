import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/either.dart';
import '../../../../core/models/failure.dart';
import '../../models/chat_model.dart';
import '../../repos/chats_repository.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _chatsRepository;
  StreamSubscription<Either<Failure, List<ChatModel>>>? _chatStreamSubscription;

  ChatsCubit({required ChatsRepository chatsRepository})
      : _chatsRepository = chatsRepository,
        super(const ChatsInitialState());

  void fetchChats(String currentUserId) {
    emit(const ChatsLoadingState());

    _chatStreamSubscription = _chatsRepository
        .fetchChats(currentUserId: currentUserId)
        .listen((result) {
      result.fold(
        (failure) => emit(ChatsErrorState(failure.message)),
        (chats) => emit(ChatsLoadedState(chats)),
      );
    });
  }

  @override
  Future<void> close() {
    _chatStreamSubscription?.cancel();
    return super.close();
  }
}
