import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'guide_logic.dart';

class GuideView extends GetView<GuideLogic> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <_GuidePage>[
      const _GuidePage(Lang.guideTitle1, Lang.guideDesc1, Icons.auto_awesome_rounded),
      const _GuidePage(Lang.guideTitle2, Lang.guideDesc2, Icons.dashboard_customize_rounded),
      const _GuidePage(Lang.guideTitle3, Lang.guideDesc3, Icons.emoji_events_rounded),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.finishGuide,
                child: Text(
                  Lang.guideSkip,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return _GuideSlide(page: pages[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Obx(() {
                final isLast = controller.pageIndex.value >= pages.length - 1;
                return Row(
                  children: <Widget>[
                    Row(
                      children: List<Widget>.generate(pages.length, (i) {
                        final active = controller.pageIndex.value == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          margin: EdgeInsets.only(right: 6.w),
                          width: active ? 22.w : 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : AppColors.border,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (isLast) {
                          await controller.finishGuide();
                        } else {
                          await controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      child: Text(isLast ? Lang.guideStart : Lang.guideNext),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _GuidePage {
  const _GuidePage(this.title, this.desc, this.icon);
  final String title;
  final String desc;
  final IconData icon;
}

class _GuideSlide extends StatelessWidget {
  const _GuideSlide({required this.page});

  final _GuidePage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(color: AppColors.border),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(page.icon, size: 56.sp, color: AppColors.primary),
          ),
          SizedBox(height: 36.h),
          Text(
            page.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16.h),
          Text(
            page.desc,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
