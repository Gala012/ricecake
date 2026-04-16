import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import 'my_works_logic.dart';

class MyWorksView extends GetView<MyWorksLogic> {
  const MyWorksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.myWorksTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Obx(() {
        final list = controller.items;
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                Lang.emptyWorks,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.reload,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final WorkRecord w = list[i];
              final String? path = w.effectiveCoverPath;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: w.placeholderColor,
                      backgroundImage: path != null ? FileImage(File(path)) : null,
                      child: path == null ? Icon(Icons.movie_rounded, color: AppColors.primary) : null,
                    ),
                  title: Text(w.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(w.tag, maxLines: 1, overflow: TextOverflow.ellipsis),
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
