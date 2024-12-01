import 'package:intl/intl.dart';

extension StringsListExtension on List<String> {
  String generateChatId() {
    final userId1 = this[0];
    final userId2 = this[1];
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }
}

extension TimeExtension on int {
  String formatIntTime() {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('hh:mm a').format(time);
  }
}
