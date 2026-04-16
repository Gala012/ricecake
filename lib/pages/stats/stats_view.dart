import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'stats_logic.dart';

List<DateTime> _statsWeekChartDates() {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  return List<DateTime>.generate(7, (int i) => today.subtract(Duration(days: 6 - i)));
}

class StatsView extends GetView<StatsLogic> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.statsTitle, style: TextStyle(fontSize: 18.sp)),
        actions: <Widget>[
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        final List<double> wk = controller.weekly;
        final double maxBar = wk.isEmpty ? 0 : wk.reduce((double a, double b) => a > b ? a : b);
        final double scale = maxBar <= 0 ? 1.0 : maxBar;
        final List<DateTime> chartDays = _statsWeekChartDates();
        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: _StatCard(title: Lang.statsWorks, value: '${controller.workCount.value}')),
                SizedBox(width: 12.w),
                Expanded(child: _StatCard(title: Lang.statsDrafts, value: '${controller.draftCount.value}')),
              ],
            ),
            SizedBox(height: 12.h),
            _StatCard(title: Lang.statsStreak, value: '${controller.streakDays.value}', wide: true),
            SizedBox(height: 24.h),
            Text(
              Lang.statsWeekly,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    Lang.statsWeeklyCaption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 120.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List<Widget>.generate(wk.length, (int i) {
                        final double v = wk[i];
                        final double h = (v / scale * 120).clamp(8.0, 120.0);
                        final double denom = wk.isEmpty ? 1 : wk.length.toDouble();
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              height: h.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.35 + (i / denom) * 0.4),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: List<Widget>.generate(wk.length, (int i) {
                      final int wd = i < chartDays.length ? chartDays[i].weekday : 1;
                      return Expanded(
                        child: Text(
                          Lang.statsWeekdayChar(wd),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, this.wide = false});

  final String title;
  final String value;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : null,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
