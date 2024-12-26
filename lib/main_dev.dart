import 'package:chat/app_config.dart';
import 'package:flutter/material.dart';

import 'chat_app.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection(flavor: AppFlavor.dev);
  await getIt<AppConfig>().initialize();
  runApp(const ChatApp());
}
