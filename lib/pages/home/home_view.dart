import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import '../main_shell/main_shell_logic.dart';
import 'home_logic.dart';

void _openDraftFromHome(WorkRecord w) {
  if (w.slides.isEmpty) {
    Get.toNamed('/pick_media', parameters: <String, String>{'workId': w.id});
  } else {
    Get.toNamed('/edit_workbench', parameters: <String, String>{'workId': w.id});
  }
}

class HomeView extends GetView<HomeLogic> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refreshLocal,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Lang.homeTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        Lang.homeSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.find<MainShellLogic>().setTab(1);
                          },
                          child: Text(
                            Lang.homeCreateCta,
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _RankingShortcut(
                        onTap: () => Get.toNamed('/ranking'),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.recentDrafts.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 12.w, 10.h),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                Lang.homeRecentDrafts,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed('/drafts'),
                              child: Text(
                                Lang.homeDraftsSeeAll,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 118.h,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.recentDrafts.length,
                          separatorBuilder: (BuildContext context, int index) => SizedBox(width: 12.w),
                          itemBuilder: (BuildContext context, int i) {
                            final WorkRecord w = controller.recentDrafts[i];
                            return SizedBox(
                              width: 132.w,
                              child: _DraftQuickCard(
                                item: w,
                                onTap: () => _openDraftFromHome(w),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Lang.homeFeatured,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/featured_list'),
                        child: Text(
                          Lang.homeSeeAll,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              Obx(() {
                final list = controller.featured;
                if (list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                          child: Text(
                            Lang.homeFeaturedEmpty,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 14.h),
                    itemBuilder: (context, i) {
                      final w = list[i];
                      return _FeaturedCard(
                        item: w,
                        onTap: () => Get.toNamed(
                          '/work_detail',
                          parameters: <String, String>{'id': w.id},
                        ),
                      );
                    },
                  ),
                );
              }),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftQuickCard extends StatelessWidget {
  const _DraftQuickCard({required this.item, required this.onTap});

  final WorkRecord item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color cover = item.placeholderColor;
    final String? path = item.effectiveCoverPath;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13.r)),
                  child: path != null
                      ? Image.file(File(path), fit: BoxFit.cover)
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                cover,
                                Color.lerp(cover, AppColors.primary, 0.12)!,
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, height: 1.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankingShortcut extends StatelessWidget {
  const _RankingShortcut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.leaderboard_rounded, color: AppColors.cta, size: 26.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  Lang.homeRankingChip,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.onTap});

  final WorkRecord item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color cover = item.placeholderColor;
    final String? path = item.effectiveCoverPath;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: SizedBox(
                  height: 140.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (path != null)
                        Image.file(File(path), fit: BoxFit.cover)
                      else
                        DecoratedBox(decoration: BoxDecoration(gradient: _softGradient(cover))),
                      Positioned(
                        left: 12.w,
                        bottom: 12.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            item.tag,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              item.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 18.sp,
                              color: item.isFavorite ? AppColors.cta : AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              item.isFavorite ? Lang.favoriteAdded : Lang.favoriteAdd,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.displayAuthorOrTag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _softGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        base,
        Color.lerp(base, AppColors.primary, 0.15)!,
      ],
    );
  }
}
