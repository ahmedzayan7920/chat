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
  late List<dynamic> groupedMessages;

  @override
  void initState() {
    super.initState();
    groupedMessages = _groupMessagesByDate(widget.messages);
  }

  @override
  void didUpdateWidget(ChatViewSuccess oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages != oldWidget.messages) {
      setState(() {
        groupedMessages = _groupMessagesByDate(widget.messages);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: groupedMessages.length,
          itemBuilder: (context, index) {
            final item = groupedMessages[groupedMessages.length - 1 - index];

            if (item is DateTime) {
              return ChatViewDateItem(date: item);
            } else if (item is MessageModel) {
              return ChatViewMessageItem(message: item);
            } else {
              return const SizedBox();
            }
          },
        );
      },
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

      if (currentDate == null || currentDate != dateOnly) {
        currentDate = dateOnly;
        groupedMessages.add(currentDate);
      }
      groupedMessages.add(message);
    }

    return groupedMessages;
  }
}
