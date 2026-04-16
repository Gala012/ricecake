import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'preview_export_logic.dart';

class PreviewExportView extends GetView<PreviewExportLogic> {
  const PreviewExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Text(Lang.previewTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: GetBuilder<PreviewExportLogic>(
        builder: (PreviewExportLogic logic) {
          final work = logic.work;
          if (work == null || work.slides.isEmpty) {
            return Center(
              child: Text(
                Lang.pickMediaEmpty,
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
            );
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  controller: logic.pageController,
                  itemCount: work.slides.length,
                  onPageChanged: logic.setPageIndex,
                  itemBuilder: (BuildContext context, int i) {
                    final slide = work.slides[i];
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.file(
                          File(slide.path),
                          fit: BoxFit.contain,
                        ),
                        if (slide.caption.isNotEmpty)
                          Positioned(
                            left: 16.w,
                            right: 16.w,
                            bottom: 32.h,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Text(
                                  slide.caption,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.h, 0, 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(work.slides.length, (int i) {
                    final bool on = i == logic.pageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: on ? 16.w : 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: on ? AppColors.cta : Colors.white30,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
