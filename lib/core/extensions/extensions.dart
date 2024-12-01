extension StringsListExtension on List<String> {
  String generateChatId() {
    final userId1 = this[0];
    final userId2 = this[1];
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }
}

extension TimeExtension on int {
  String formatTime() {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(this);
    final String formattedTime =
        "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    return formattedTime;
  }
}