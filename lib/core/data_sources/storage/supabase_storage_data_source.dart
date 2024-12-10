import 'dart:io';

import 'storage_data_source.dart';
import '../../models/either.dart';
import '../../models/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageDataSource implements StorageDataSource {
  final SupabaseClient _supabaseClient;

  SupabaseStorageDataSource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;
  @override
  Future<Either<Failure, String>> uploadFile({
    required String filePath,
    required String fileName,
    required String bucketName,
  }) async {
    try {
      File file = File(filePath);
      String fullName = '$fileName.${file.path.split('.').last}';
      await _supabaseClient.storage.from(bucketName).upload(
            fullName,
            file,
          );
      String url =
          _supabaseClient.storage.from(bucketName).getPublicUrl(fullName);
      return Either.right(url);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
