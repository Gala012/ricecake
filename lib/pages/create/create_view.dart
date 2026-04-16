import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'create_logic.dart';
import 'create_scene_icons.dart';

class CreateView extends GetView<CreateLogic> {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _CreateEntrance(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const _CreateHero(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() {
                    final List<String> tags = controller.categories.toList();
                    return _SceneTemplatePanel(
                      tags: tags,
                      onSelect: controller.startWithTag,
                    );
                  }),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.route_rounded,
                            color: AppColors.cta,
                            size: 22.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              Lang.createSteps,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateEntrance extends StatefulWidget {
  const _CreateEntrance({required this.child});

  final Widget child;

  @override
  State<_CreateEntrance> createState() => _CreateEntranceState();
}

class _CreateEntranceState extends State<_CreateEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool reduce = MediaQuery.disableAnimationsOf(context);
      if (reduce) {
        _ac.duration = Duration.zero;
      }
      _ac.forward();
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (BuildContext context, Widget? child) {
        final CurvedAnimation curve = CurvedAnimation(
          parent: _ac,
          curve: Curves.easeOutCubic,
        );
        return Opacity(
          opacity: curve.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curve.value) * 18),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _CreateHero extends StatelessWidget {
  const _CreateHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary.withValues(alpha: 0.14),
            AppColors.secondary.withValues(alpha: 0.2),
            AppColors.cta.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.auto_fix_high_rounded,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        Lang.createPickTemplate,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              Lang.createTitle,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: AppColors.textPrimary,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              Lang.createHeroSubtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.45,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneTemplatePanel extends StatelessWidget {
  const _SceneTemplatePanel({required this.tags, required this.onSelect});

  final List<String> tags;
  final Future<void> Function(String tag) onSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          child: Text(
                            '${tags.length}${Lang.createSceneBadgeSuffix}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.category_rounded,
                        size: 22.sp,
                        color: AppColors.textSecondary.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 4.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          Lang.createSectionTemplates,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    Lang.createTapHint,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: AppColors.border.withValues(alpha: 0.85)),
            for (int i = 0; i < tags.length; i++)
              _SceneTemplateRow(
                tag: tags[i],
                showDivider: i > 0,
                onTap: () => onSelect(tags[i]),
              ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

class _SceneTemplateRow extends StatelessWidget {
  const _SceneTemplateRow({required this.tag, required this.showDivider, required this.onTap});

  final String tag;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = sceneIconForTag(tag);
    final Color tint = sceneTintForTag(tag);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 68.w,
            endIndent: 14.w,
            color: AppColors.border.withValues(alpha: 0.75),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primary.withValues(alpha: 0.09),
            highlightColor: AppColors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 12.w, 12.h),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          tint,
                          Color.lerp(tint, AppColors.secondary, 0.2) ?? tint,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 24.sp),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tag,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          Lang.createStart,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cta,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.sp,
                    color: AppColors.textSecondary.withValues(alpha: 0.75),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
