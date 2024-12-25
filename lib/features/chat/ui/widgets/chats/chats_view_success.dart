import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chats/chats_cubit.dart';
import '../../../logic/chats/chats_state.dart';
import '../../../models/chat_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/spaces.dart';
import 'chats_view_item.dart';

class ChatsViewSuccess extends StatefulWidget {
  const ChatsViewSuccess({
    super.key,
    required this.chats,
    required this.currentUserId,
    required this.hasMore,
    required this.isLoading,
  });
  final List<ChatModel> chats;
  final String currentUserId;
  final bool hasMore;
  final bool isLoading;

  @override
  State<ChatsViewSuccess> createState() => _ChatsViewSuccessState();
}

class _ChatsViewSuccessState extends State<ChatsViewSuccess> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if ((!_isLoadingMore && widget.hasMore) ||
          ((context.read<ChatsCubit>().state is ChatsErrorState) &&
              widget.hasMore)) {
        _isLoadingMore = true;
        context
            .read<ChatsCubit>()
            .loadMoreChats(currentUserId: widget.currentUserId);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: (widget.hasMore ? 1 : 0) + (widget.chats.length),
      separatorBuilder: (context, index) => const VerticalSpace(height: 8),
      itemBuilder: (context, index) {
        if (index == (widget.chats.length) && widget.hasMore) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final chat = widget.chats[index];
        return ChatsViewItem(chat: chat);
      },
    );
  }
}
