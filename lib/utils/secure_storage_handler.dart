import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHandler {
  static const String _authKey = 'is_authenticated';

  final FlutterSecureStorage _storage;

  SecureStorageHandler({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  Future<void> saveAuthenticationStatus(bool isAuthenticated) async {
    try {
      await _storage.write(key: _authKey, value: isAuthenticated.toString());
    } catch (e) {
      print("Error saving authentication status: $e");
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final value = await _storage.read(key: _authKey);
      return value == 'true';
    } catch (e) {
      print("Error reading authentication status: $e");
      return false;
    }
  }

  Future<void> clearAuthentication() async {
    try {
      await _storage.delete(key: _authKey);
    } catch (e) {
      print("Error clearing authentication status: $e");
    }
  }
}
