import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/app/app.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';
import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/core/storage/secure_storage_service.dart';
import 'package:base_flutter_ai/core/storage/storage_service.dart';
import 'package:base_flutter_ai/core/utils/logger.dart';

Future<void> bootstrapApp(EnvConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment Configuration
  AppConfig.initialize(config);
  AppLogger.i(
    'Initialized ${config.appTitle} in ${config.environment.name} mode',
  );

  // Initialize Core Storage Services
  await Get.putAsync<StorageService>(() => StorageService().init());
  await Get.putAsync<SecureStorageService>(() => SecureStorageService().init());

  runApp(const App());
}
