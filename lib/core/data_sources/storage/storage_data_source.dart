import '../../models/either.dart';
import '../../models/failure.dart';

abstract class StorageDataSource {
  Future<Either<Failure, String>> uploadFile({
    required String filePath,
    required String fileName,
    required String bucketName,
  });
}