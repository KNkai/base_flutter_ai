import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/main_common.dart';

void main() async {
  await bootstrapApp(
    const EnvConfig(
      environment: Environment.staging,
      appTitle: 'Flutter AI (Staging)',
      apiBaseUrl: 'https://staging-api.example.com',
      enableLogging: true,
    ),
  );
}
