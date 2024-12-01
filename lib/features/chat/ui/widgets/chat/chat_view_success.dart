import 'package:flutter/material.dart';

import '../../../models/message_model.dart';
import 'chat_view_date_item.dart';
import 'chat_view_message_item.dart';

class ChatViewSuccess extends StatefulWidget {
  const ChatViewSuccess({
    super.key,
    required this.messages,
  });

  final List<MessageModel> messages;

  @override
  State<ChatViewSuccess> createState() => _ChatViewSuccessState();
}

class _ChatViewSuccessState extends State<ChatViewSuccess> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _previousMessages = [];

  @override
  Widget build(BuildContext context) {
    final groupedMessages = _groupMessagesByDate(widget.messages);

    return ListView.builder(
      controller: _scrollController,
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final item = groupedMessages[index];

        if (item is DateTime) {
          return ChatViewDateItem(date: item);
        } else if (item is MessageModel) {
          return ChatViewMessageItem(message: item);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _previousMessages = widget.messages;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatViewSuccess oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.length > _previousMessages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
    _previousMessages = widget.messages;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        maxScroll + 500,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<dynamic> _groupMessagesByDate(List<MessageModel> messages) {
    final List<dynamic> groupedMessages = [];
    DateTime? currentDate;

    for (final message in messages.reversed) {
      final messageDate =
          DateTime.fromMillisecondsSinceEpoch(message.time).toLocal();
      final dateOnly =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      if (currentDate == null || currentDate != dateOnly) {
        currentDate = dateOnly;
        groupedMessages.add(currentDate);
      }
      groupedMessages.add(message);
    }

    return groupedMessages;
  }
}
