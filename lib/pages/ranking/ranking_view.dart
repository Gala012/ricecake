import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'ranking_logic.dart';

class RankingView extends GetView<RankingLogic> {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.rankingTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Obx(() {
        final list = controller.ranked;
        if (list.isEmpty) {
          return Center(child: Text(Lang.emptyRanking));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.reload,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            itemCount: list.length,
            itemBuilder: (context, i) {
            final w = list[i];
            final rank = i + 1;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: rank <= 3 ? AppColors.cta.withValues(alpha: 0.2) : AppColors.background,
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: rank <= 3 ? AppColors.cta : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  title: Text(w.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    w.tagAndOptionalAuthorLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                  onTap: () => Get.toNamed(
                    '/work_detail',
                    parameters: <String, String>{'id': w.id},
                  ),
                ),
              ),
            );
          },
          ),
        );
      }),
    );
  }
}
