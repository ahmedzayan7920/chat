import 'package:flutter/material.dart';

import 'app_config.dart';
import 'chat_app.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection(flavor: AppFlavor.prod);
  await getIt<AppConfig>().initialize();
  runApp(const ChatApp());
}
