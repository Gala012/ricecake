import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'profile_logic.dart';

class ProfileView extends GetView<ProfileLogic> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <_ProfileEntry>[
      _ProfileEntry(Lang.profileMyWorks, Icons.folder_open_rounded, '/my_works'),
      _ProfileEntry(Lang.profileDrafts, Icons.edit_note_rounded, '/drafts'),
      _ProfileEntry(Lang.profileRanking, Icons.leaderboard_rounded, '/ranking'),
      _ProfileEntry(Lang.profileStats, Icons.insights_rounded, '/stats'),
      _ProfileEntry(Lang.profileHelp, Icons.help_outline_rounded, '/help'),
      _ProfileEntry(Lang.profileAbout, Icons.info_outline_rounded, '/about'),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.reloadStats,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Lang.profileTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        Lang.appName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Obx(() {
                    return Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _ProfileDashCell(
                                value: '${controller.publishedCount.value}',
                                label: Lang.profileStatPublished,
                                onTap: () => Get.toNamed('/my_works'),
                              ),
                            ),
                            Container(width: 1, height: 40.h, color: AppColors.border),
                            Expanded(
                              child: _ProfileDashCell(
                                value: '${controller.draftCount.value}',
                                label: Lang.profileStatDrafts,
                                onTap: () => Get.toNamed('/drafts'),
                              ),
                            ),
                            Container(width: 1, height: 40.h, color: AppColors.border),
                            Expanded(
                              child: _ProfileDashCell(
                                value: '${controller.favoriteCount.value}',
                                label: Lang.profileStatFavorites,
                                onTap: () => Get.toNamed('/ranking'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverList.separated(
                  itemCount: tiles.length,
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.h),
                  itemBuilder: (context, i) {
                    final t = tiles[i];
                    return Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        leading: Icon(t.icon, color: AppColors.primary),
                        title: Text(
                          t.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                        onTap: () async {
                          await Get.toNamed(t.route);
                          controller.reloadStats();
                        },
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileDashCell extends StatelessWidget {
  const _ProfileDashCell({required this.value, required this.label, required this.onTap});

  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileEntry {
  const _ProfileEntry(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}
