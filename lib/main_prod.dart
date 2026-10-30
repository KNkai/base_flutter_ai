import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/main_common.dart';

void main() async {
  await bootstrapApp(
    const EnvConfig(
      environment: Environment.prod,
      appTitle: 'Flutter AI',
      apiBaseUrl: 'https://api.example.com',
      enableLogging: false,
    ),
  );
}
