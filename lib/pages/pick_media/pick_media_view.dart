import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/slide_item.dart';
import '../../theme/app_colors.dart';
import 'pick_media_logic.dart';

class PickMediaView extends GetView<PickMediaLogic> {
  const PickMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.pickMediaTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
            child: Text(
              Lang.pickMediaHint,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: OutlinedButton.icon(
              onPressed: controller.pickFromGallery,
              icon: Icon(Icons.photo_library_outlined, size: 22.sp),
              label: Text(Lang.pickMediaGallery),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Obx(() {
              final list = controller.slides;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    Lang.pickMediaEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                ),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) {
                  final SlideItem item = list[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(item.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 4.w,
                        top: 4.h,
                        child: Material(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(99),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(99),
                            onTap: () => controller.removeAt(i),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(Icons.close_rounded, color: Colors.white, size: 18.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: ElevatedButton(
              onPressed: () => controller.goEdit(),
              child: Text(Lang.pickMediaNext, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
