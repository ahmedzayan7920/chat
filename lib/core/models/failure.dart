import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

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
    } else {
      return Failure(e.toString());
    }
  }
}
