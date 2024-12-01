import 'package:chat/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatViewDateItem extends StatelessWidget {
  const ChatViewDateItem({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(date),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));

  if (DateUtils.isSameDay(date, today)) {
    return AppStrings.today;
  } else if (DateUtils.isSameDay(date, yesterday)) {
    return AppStrings.yesterday;
  } else {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
}
