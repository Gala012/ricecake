import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import 'featured_list_logic.dart';

class FeaturedListView extends GetView<FeaturedListLogic> {
  const FeaturedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.featuredListTitle, style: TextStyle(fontSize: 18.sp)),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: controller.setSort,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(value: 0, child: Text(Lang.featuredSortFavoriteFirst)),
              PopupMenuItem<int>(value: 1, child: Text(Lang.featuredSortTime)),
            ],
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.sort_rounded, size: 22.sp),
                  SizedBox(width: 4.w),
                  Text(Lang.featuredSortTitle, style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.h),
          Obx(() {
            final List<String> tags = List<String>.from(controller.tagOptions);
            final String? selectedTag = controller.tagFilter.value;
            return SizedBox(
              height: 44.h,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChip(
                      label: Text(Lang.featuredFilterAll, style: TextStyle(fontSize: 13.sp)),
                      selected: selectedTag == null,
                      onSelected: (_) => controller.setTag(null),
                    ),
                  ),
                  ...tags.map((String t) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: FilterChip(
                        label: Text(
                          t,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        selected: selectedTag == t,
                        onSelected: (bool v) => controller.setTag(v ? t : null),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              final List<WorkRecord> list = controller.items;
              if (list.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.reload,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            Lang.featuredListEmpty,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.reload,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                  itemCount: list.length,
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12.h),
                  itemBuilder: (BuildContext context, int i) {
                    final WorkRecord w = list[i];
                    final String? path = w.effectiveCoverPath;
                    return ListTile(
                      tileColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: w.placeholderColor,
                        backgroundImage: path != null ? FileImage(File(path)) : null,
                        child: path == null ? Icon(Icons.image_rounded, color: AppColors.primary) : null,
                      ),
                      title: Text(
                        w.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
