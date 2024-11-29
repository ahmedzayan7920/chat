
abstract class NotificationRepository {
  
  Future<void> initialize();

  Future<void> saveToken(String? token);

  Future<String?> getToken();

  Future<void> dispose();
}
