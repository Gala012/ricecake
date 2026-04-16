import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import 'work_detail_logic.dart';

class WorkDetailView extends GetView<WorkDetailLogic> {
  const WorkDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.workDetailTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Obx(() {
        final WorkRecord? w = controller.item.value;
        if (w == null) {
          return Center(
            child: Text(
              '—',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
            ),
          );
        }
        final Color cover = w.placeholderColor;
        final String? path = w.effectiveCoverPath;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: SizedBox(
                  height: 220.h,
                  child: path != null
                      ? Image.file(File(path), fit: BoxFit.cover)
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[cover, AppColors.secondary.withValues(alpha: 0.35)],
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.play_circle_fill_rounded, size: 64.sp, color: Colors.white70),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      w.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        controller.toggleFavorite();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              w.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 22.sp,
                              color: w.isFavorite ? AppColors.cta : AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              w.isFavorite ? Lang.favoriteAdded : Lang.favoriteAdd,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                w.tagAndOptionalAuthorLine,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 28.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: w.slides.isEmpty ? null : controller.openPreview,
                      child: Text(Lang.actionPreview),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.openEditFlow,
                      child: Text(Lang.actionEdit),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
