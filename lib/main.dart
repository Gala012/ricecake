import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'db_rice_cake/db_rice_cake_helper.dart';
import 'lang/lang.dart';
import '../pages/about/about_binding.dart';
import '../pages/about/about_view.dart';
import '../pages/drafts/drafts_binding.dart';
import '../pages/drafts/drafts_view.dart';
import '../pages/edit_workbench/edit_workbench_binding.dart';
import '../pages/edit_workbench/edit_workbench_view.dart';
import '../pages/guide/guide_binding.dart';
import '../pages/guide/guide_view.dart';
import '../pages/help/help_binding.dart';
import '../pages/help/help_view.dart';
import '../pages/home/featured_list_binding.dart';
import '../pages/home/featured_list_view.dart';
import '../pages/main_shell/main_shell_binding.dart';
import '../pages/main_shell/main_shell_view.dart';
import '../pages/pick_media/pick_media_binding.dart';
import '../pages/pick_media/pick_media_view.dart';
import '../pages/preview_export/preview_export_binding.dart';
import '../pages/preview_export/preview_export_view.dart';
import '../pages/my_works/my_works_binding.dart';
import '../pages/my_works/my_works_view.dart';
import '../pages/ranking/ranking_binding.dart';
import '../pages/ranking/ranking_view.dart';
import '../pages/stats/stats_binding.dart';
import '../pages/stats/stats_view.dart';
import '../pages/work_detail/work_detail_binding.dart';
import '../pages/work_detail/work_detail_view.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbRiceCakeHelper.instance.init();
  final onboardingDone = await DbRiceCakeHelper.instance.getSetting('onboarding_done');
  final showGuide = onboardingDone != '1';
  runApp(RiceCakeApp(showGuide: showGuide));
}

class RiceCakeApp extends StatelessWidget {
  const RiceCakeApp({super.key, required this.showGuide});

  final bool showGuide;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: Lang.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: showGuide ? '/guide' : '/main',
          getPages:Cake,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 220),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Cake = [
  GetPage(
    name: '/guide',
    page: () => const GuideView(),
    binding: GuideBinding(),
  ),
  GetPage(
    name: '/main',
    page: () => const MainShellView(),
    binding: MainShellBinding(),
  ),
  GetPage(
    name: '/pick_media',
    page: () => const PickMediaView(),
    binding: PickMediaBinding(),
  ),
  GetPage(
    name: '/edit_workbench',
    page: () => const EditWorkbenchView(),
    binding: EditWorkbenchBinding(),
  ),
  GetPage(
    name: '/preview_export',
    page: () => const PreviewExportView(),
    binding: PreviewExportBinding(),
  ),
  GetPage(
    name: '/featured_list',
    page: () => const FeaturedListView(),
    binding: FeaturedListBinding(),
  ),
  GetPage(
    name: '/work_detail',
    page: () => const WorkDetailView(),
    binding: WorkDetailBinding(),
  ),
  GetPage(
    name: '/my_works',
    page: () => const MyWorksView(),
    binding: MyWorksBinding(),
  ),
  GetPage(
    name: '/drafts',
    page: () => const DraftsView(),
    binding: DraftsBinding(),
  ),
  GetPage(
    name: '/ranking',
    page: () => const RankingView(),
    binding: RankingBinding(),
  ),
  GetPage(
    name: '/stats',
    page: () => const StatsView(),
    binding: StatsBinding(),
  ),
  GetPage(
    name: '/help',
    page: () => const HelpView(),
    binding: HelpBinding(),
  ),
  GetPage(
    name: '/about',
    page: () => const AboutView(),
    binding: AboutBinding(),
  ),
];