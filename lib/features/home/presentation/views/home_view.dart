import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/core/constants/app_constants.dart';
import 'package:base_flutter_ai/core/widgets/app_empty_view.dart';
import 'package:base_flutter_ai/core/widgets/app_error_view.dart';
import 'package:base_flutter_ai/core/widgets/app_loading_indicator.dart';
import 'package:base_flutter_ai/core/widgets/app_text_field.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';
import 'package:base_flutter_ai/features/home/presentation/widgets/home_header.dart';
import 'package:base_flutter_ai/features/home/presentation/widgets/post_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starter Kit Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              Get.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refreshPosts,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshPosts,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth >= AppConstants.mobileBreakpoint;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    const SliverToBoxAdapter(
                      child: HomeHeader(
                        title: 'Production-Grade Flutter + AI',
                        subtitle: 'Clean architecture, GetX state management, and specialized agent workflows.',
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverToBoxAdapter(
                      child: AppTextField(
                        hintText: 'Search architecture topics...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        onChanged: controller.updateSearchQuery,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    Obx(() {
                      if (controller.isLoading && controller.posts.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppLoadingIndicator(
                            message: 'Loading architecture posts...',
                          ),
                        );
                      }

                      if (controller.errorMessage != null &&
                          controller.posts.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppErrorView(
                            message: controller.errorMessage!,
                            onRetry: controller.fetchPosts,
                          ),
                        );
                      }

                      final items = controller.filteredPosts;
                      if (items.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppEmptyView(
                            title: 'No matching posts',
                            message: controller.searchQuery.isNotEmpty
                                ? 'No posts match "${controller.searchQuery}".'
                                : 'No posts are currently available.',
                          ),
                        );
                      }

                      if (isWide) {
                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => PostCard(post: items[index]),
                            childCount: items.length,
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => PostCard(post: items[index]),
                          childCount: items.length,
                        ),
                      );
                    }),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
