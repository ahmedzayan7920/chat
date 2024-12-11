import 'package:chat/core/data_sources/storage/storage_data_source.dart';

import '../../models/either.dart';
import '../../models/failure.dart';
import 'storage_repository.dart';

class SupabaseStorageRepository implements StorageRepository {
  final StorageDataSource _storageDataSource;

  SupabaseStorageRepository({required StorageDataSource storageDataSource})
      : _storageDataSource = storageDataSource;

  @override
  Future<Either<Failure, String>> uploadFile({
   required String filePath,
   required String fileName,
  required  String bucketName,
  }) {
    return _storageDataSource.uploadFile(
      filePath: filePath,
      fileName: fileName,
      bucketName: bucketName,
    );
  }
}
