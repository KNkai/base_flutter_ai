import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/app/bindings/initial_binding.dart';
import 'package:base_flutter_ai/app/routes/app_pages.dart';
import 'package:base_flutter_ai/app/theme/app_theme.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.environment.appTitle,
      debugShowCheckedModeBanner: AppConfig.isDev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.cupertino,
    );
  }
}
