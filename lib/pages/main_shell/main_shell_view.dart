import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import '../create/create_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import 'main_shell_logic.dart';

class MainShellView extends GetView<MainShellLogic> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final idx = controller.tabIndex.value;
      return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          child: <Widget>[
            const HomeView(key: ValueKey<String>('home')),
            const CreateView(key: ValueKey<String>('create')),
            const ProfileView(key: ValueKey<String>('profile')),
          ][idx],
        ),
        bottomNavigationBar: NavigationBar(
          height: 64.h,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          selectedIndex: idx,
          onDestinationSelected: controller.setTab,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.explore_outlined, size: 22.sp),
              selectedIcon: Icon(Icons.explore_rounded, size: 22.sp, color: AppColors.primary),
              label: Lang.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded, size: 22.sp),
              selectedIcon: Icon(Icons.add_circle_rounded, size: 22.sp, color: AppColors.primary),
              label: Lang.navCreate,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, size: 22.sp),
              selectedIcon: Icon(Icons.person_rounded, size: 22.sp, color: AppColors.primary),
              label: Lang.navProfile,
            ),
          ],
        ),
      );
    });
  }
}
