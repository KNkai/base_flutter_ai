import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/core/utils/logger.dart';

class SecureStorageService extends GetxService {
  late final FlutterSecureStorage _storage;

  Future<SecureStorageService> init() async {
    const aOptions = AndroidOptions(encryptedSharedPreferences: true);
    const iOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );

    _storage = const FlutterSecureStorage(
      aOptions: aOptions,
      iOptions: iOptions,
    );
    AppLogger.i('SecureStorageService initialized');
    return this;
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, st) {
      AppLogger.e('Error reading from SecureStorage key: $key', e, st);
      return null;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, st) {
      AppLogger.e('Error writing to SecureStorage key: $key', e, st);
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, st) {
      AppLogger.e('Error deleting from SecureStorage key: $key', e, st);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, st) {
      AppLogger.e('Error clearing SecureStorage', e, st);
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, st) {
      AppLogger.e('Error checking key in SecureStorage: $key', e, st);
      return false;
    }
  }
}
