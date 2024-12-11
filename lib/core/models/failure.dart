import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Failure {
  final String message;

  const Failure(this.message);

  factory Failure.fromException(dynamic e) {
    if (e is FirebaseAuthException) {
      return Failure(e.message ?? e.toString());
    } else if (e is FirebaseException) {
      return Failure(e.message ?? e.toString());
    } else if (e is SocketException) {
      return Failure(e.message);
    } else if (e is PathNotFoundException) {
      return Failure(e.message);
    } else if (e is PostgrestException) {
      return Failure(e.message);
    } else if (e is StorageException) {
      return Failure(e.message);
    } else {
      return Failure(e.toString());
    }
  }
}
