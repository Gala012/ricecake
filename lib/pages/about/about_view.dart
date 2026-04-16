import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'about_logic.dart';

const String _kAboutEn = '''
Rice Cake Slideshow Studio helps you turn everyday photos into warm, story-driven montages. The experience is tuned for quick creation: bold blocks of color, generous spacing, and bottom sheets instead of cramped dialogs.

This application runs entirely offline. No accounts, no cloud sync, and no background upload pipelines—your library stays on the phone or tablet you are holding.

We focus on discoverability for inspiration, a dedicated creation lane with scene-based templates, and a profile hub for works, drafts, favorites, and learning resources.

Thank you for trying the preview build. Share feedback from your usual channels on the device once collaboration features arrive in later milestones.
''';

class AboutView extends GetView<AboutLogic> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.aboutTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Lang.aboutBodyTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            Text(
              _kAboutEn,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.55,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
