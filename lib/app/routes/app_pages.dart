import 'package:get/get.dart';
import 'package:base_flutter_ai/app/routes/app_routes.dart';
import 'package:base_flutter_ai/features/home/presentation/bindings/home_binding.dart';
import 'package:base_flutter_ai/features/home/presentation/views/home_view.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.home;

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
