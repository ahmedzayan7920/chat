import 'package:chat/features/chat/logic/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chat/chat_cubit.dart';
import '../../../models/message_model.dart';
import 'chat_view_date_item.dart';
import 'chat_view_message_item.dart';

class ChatViewSuccess extends StatefulWidget {
  const ChatViewSuccess({
    super.key,
    required this.messages,
    required this.chatId,
    required this.hasMore,
    required this.isLoading,
  });

  final List<MessageModel> messages;
  final String chatId;
  final bool hasMore;
  final bool isLoading;

  @override
  State<ChatViewSuccess> createState() => _ChatViewSuccessState();
}

class _ChatViewSuccessState extends State<ChatViewSuccess> {
  final ScrollController _scrollController = ScrollController();
  late List<dynamic> groupedMessages;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    groupedMessages = _groupMessagesByDate(widget.messages);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ChatViewSuccess oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages != oldWidget.messages) {
      setState(() {
        groupedMessages = _groupMessagesByDate(widget.messages);
      });
      if (widget.messages.isNotEmpty &&
          oldWidget.messages.isNotEmpty &&
          widget.messages.length > oldWidget.messages.length &&
          widget.messages.first.time != oldWidget.messages.first.time &&
          widget.isLoading == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }
    if (widget.isLoading != oldWidget.isLoading) {
      _isLoadingMore = widget.isLoading;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if ((!_isLoadingMore && widget.hasMore) ||
          ((context.read<ChatCubit>().state is ChatErrorState) &&
              widget.hasMore)) {
        _isLoadingMore = true;
        context.read<ChatCubit>().loadMoreMessages(chatId: widget.chatId);
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
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: (widget.hasMore ? 1 : 0) + groupedMessages.length,
          itemBuilder: (context, index) {
            if (index == groupedMessages.length && widget.hasMore) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = groupedMessages.toList()[index];

            if (item is DateTime) {
              return ChatViewDateItem(date: item);
            } else if (item is MessageModel) {
              return ChatViewMessageItem(message: item);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  List<dynamic> _groupMessagesByDate(List<MessageModel> messages) {
    final List<dynamic> groupedMessages = [];
    DateTime? currentDate;

    for (final message in messages) {
      final messageDate =
          DateTime.fromMillisecondsSinceEpoch(message.time).toLocal();
      final dateOnly =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      if (currentDate == null || currentDate == dateOnly) {
        groupedMessages.add(message);
        currentDate = dateOnly;
      } else {
        groupedMessages.add(currentDate);
        groupedMessages.add(message);
        currentDate = dateOnly;
      }
    }

    if (messages.isNotEmpty) {
      groupedMessages.add(
          DateTime.fromMillisecondsSinceEpoch(messages.last.time).toLocal());
    }
    return groupedMessages;
  }
}
