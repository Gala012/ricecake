import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../models/work_record.dart';
import '../../theme/app_colors.dart';
import 'edit_workbench_logic.dart';

class EditWorkbenchView extends GetView<EditWorkbenchLogic> {
  const EditWorkbenchView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.editWorkbenchTitle, style: TextStyle(fontSize: 18.sp)),
        actions: <Widget>[
          TextButton(
            onPressed: () => controller.saveDraft(),
            child: Text(
              Lang.editSaveDraft,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: GetBuilder<EditWorkbenchLogic>(
        builder: (EditWorkbenchLogic logic) {
          final WorkRecord? w = logic.work;
          if (w == null) {
            return const Center(child: SizedBox.shrink());
          }
          if (w.slides.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: _EmptySlidesCard(
                  onAddMedia: () => Get.toNamed(
                    '/pick_media',
                    parameters: <String, String>{'workId': w.id},
                  ),
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    _WorkbenchHeroMeta(tag: w.tag, slideCount: w.slides.length),
                    SizedBox(height: 16.h),
                    Text(
                      Lang.editTitleLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _TitleCard(controller: logic.titleController),
                    SizedBox(height: 22.h),
                    _SectionHeading(text: Lang.editCaptionSection),
                    SizedBox(height: 14.h),
                    ...List<Widget>.generate(w.slides.length, (int i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _SlideCaptionCard(
                          index: i,
                          imagePath: w.slides[i].path,
                          captionController: logic.captionControllers[i],
                        ),
                      );
                    }),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
              Material(
                elevation: 12,
                shadowColor: AppColors.primary.withValues(alpha: 0.12),
                color: AppColors.surface,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () => logic.saveChanges(),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: AppColors.cta,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          Lang.editSave,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptySlidesCard extends StatelessWidget {
  const _EmptySlidesCard({required this.onAddMedia});

  final VoidCallback onAddMedia;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.secondary.withValues(alpha: 0.35),
                    AppColors.primary.withValues(alpha: 0.18),
                  ],
                ),
              ),
              child: Icon(Icons.add_photo_alternate_outlined, size: 44.sp, color: AppColors.primary),
            ),
            SizedBox(height: 22.h),
            Text(
              Lang.pickMediaEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(height: 1.25),
            ),
            SizedBox(height: 10.h),
            Text(
              Lang.editEmptyStateSubtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton.icon(
                onPressed: onAddMedia,
                icon: Icon(Icons.photo_library_outlined, size: 22.sp, color: AppColors.primary),
                label: Text(
                  Lang.pickMediaGallery,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.55), width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkbenchHeroMeta extends StatelessWidget {
  const _WorkbenchHeroMeta({required this.tag, required this.slideCount});

  final String tag;
  final int slideCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary.withValues(alpha: 0.14),
            AppColors.background,
            AppColors.secondary.withValues(alpha: 0.08),
          ],
          stops: const <double>[0.0, 0.55, 1.0],
        ),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                tag,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                Lang.editSlidesSummary(slideCount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 2,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        decoration: InputDecoration(
          hintText: Lang.editTitleLabel,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.45),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 4.w,
          height: 22.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _SlideCaptionCard extends StatelessWidget {
  const _SlideCaptionCard({
    required this.index,
    required this.imagePath,
    required this.captionController,
  });

  final int index;
  final String imagePath;
  final TextEditingController captionController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SlideThumbBadge(index: index + 1, path: imagePath),
            SizedBox(width: 14.w),
            Expanded(
              child: TextField(
                controller: captionController,
                maxLines: 4,
                minLines: 3,
                maxLength: 120,
                buildCounter: (
                  BuildContext context, {
                  required int currentLength,
                  required bool isFocused,
                  required int? maxLength,
                }) {
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      '$currentLength / ${maxLength ?? 120}',
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                    ),
                  );
                },
                style: TextStyle(fontSize: 15.sp, height: 1.4, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: '${Lang.editSlideCaption} ${index + 1}',
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  floatingLabelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.background.withValues(alpha: 0.55),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideThumbBadge extends StatelessWidget {
  const _SlideThumbBadge({required this.index, required this.path});

  final int index;
  final String path;

  @override
  Widget build(BuildContext context) {
    final bool exists = path.isNotEmpty && File(path).existsSync();
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            width: 92.w,
            height: 92.w,
            child: exists
                ? Image.file(File(path), fit: BoxFit.cover)
                : ColoredBox(
                    color: AppColors.border,
                    child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary, size: 32.sp),
                  ),
          ),
        ),
        Positioned(
          left: 8.w,
          top: 8.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
              child: Text(
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
