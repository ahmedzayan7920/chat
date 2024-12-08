import 'package:intl/intl.dart';

import '../../features/auth/logic/auth_cubit.dart';
import '../../features/auth/logic/auth_state.dart';
import '../../features/chat/models/chat_model.dart';

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

extension AuthCubitExtensions on AuthCubit {
  String get currentUserId => (state as AuthenticatedState).user.id;
}

extension ChatModelExtensions on ChatModel {
  String getOtherUserId(String currentUserId) {
    return members.firstWhere((id) => id != currentUserId);
  }
}

extension DurationExtensions on Duration {
  String formatDuration() {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
