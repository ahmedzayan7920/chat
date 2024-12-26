import 'package:chat/prod_firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/dependency_injection.dart';
import 'core/supabase/supabase_constants.dart';
import 'dev_firebase_options.dart';

enum AppFlavor {
  dev,
  prod,
}

class AppConfig {
  final AppFlavor appFlavor;
  late Map<String, String> _config;

  AppConfig({
    required this.appFlavor,
  });

  initialize() async {
    await _loadConfig();
    await _initFirebase();
    await _initSupabase();
    _initCrashlytics();
  }

  Future<void> _loadConfig() async {
    final envFile = appFlavor == AppFlavor.prod ? '.env.prod' : '.env.dev';
    await dotenv.load(fileName: envFile);
    _config = {
      SupabaseConstants.supabaseUrl: dotenv.env[SupabaseConstants.supabaseUrl]!,
      SupabaseConstants.supabaseAnonKey:
          dotenv.env[SupabaseConstants.supabaseAnonKey]!,
    };
  }

  void _initCrashlytics() {
    if (!kDebugMode) {
      FlutterError.onError = (errorDetails) {
        getIt<FirebaseCrashlytics>().recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        getIt<FirebaseCrashlytics>().recordError(error, stack, fatal: true);
        return true;
      };
    }
  }

  Future<void> _initSupabase() async {
    await Supabase.initialize(
      url: _config[SupabaseConstants.supabaseUrl]!,
      anonKey: _config[SupabaseConstants.supabaseAnonKey]!,
    );
  }

  Future<void> _initFirebase() async {
    final options = appFlavor == AppFlavor.prod
        ? ProdFirebaseOptions.currentPlatform
        : DevFirebaseOptions.currentPlatform;
    await Firebase.initializeApp(options: options);
  }
}
