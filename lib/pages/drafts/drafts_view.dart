import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import 'drafts_logic.dart';

void _showDeleteDraftBottomSheet(BuildContext context, DraftsLogic logic, WorkRecord w) {
  Get.bottomSheet<void>(
    Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        12.h + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            Lang.draftDeleteTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          SizedBox(height: 10.h),
          Text(
            w.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.35),
          ),
          SizedBox(height: 24.h),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back<void>(),
                  child: Text(Lang.draftDeleteCancel, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Get.back<void>();
                    await logic.deleteDraft(w.id);
                  },
                  child: Text(Lang.actionDelete, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class DraftsView extends GetView<DraftsLogic> {
  const DraftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.draftsTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Obx(() {
        final list = controller.items;
        if (list.isEmpty) {
          return Center(
            child: Text(
              Lang.emptyDrafts,
              style: Theme.of(context).textTheme.bodyLarge,
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
            final w = list[i];
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
                  leading: Icon(Icons.edit_note_rounded, color: AppColors.cta, size: 28.sp),
                  title: Text(w.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(Lang.actionEdit, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary, size: 24.sp),
                    tooltip: Lang.actionDelete,
                    onPressed: () => _showDeleteDraftBottomSheet(context, controller, w),
                  ),
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
