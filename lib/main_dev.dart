import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/main_common.dart';

void main() async {
  await bootstrapApp(
    const EnvConfig(
      environment: Environment.dev,
      appTitle: 'Flutter AI (Dev)',
      apiBaseUrl: 'https://jsonplaceholder.typicode.com',
      enableLogging: true,
    ),
  );
}
