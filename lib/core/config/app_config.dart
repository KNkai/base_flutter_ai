import 'package:base_flutter_ai/core/config/env_config.dart';

class AppConfig {
  AppConfig._();

  static late final EnvConfig _environment;

  static void initialize(EnvConfig config) {
    _environment = config;
  }

  static EnvConfig get environment => _environment;
  static bool get isDev => _environment.isDev;
  static bool get isStaging => _environment.isStaging;
  static bool get isProd => _environment.isProd;
}
