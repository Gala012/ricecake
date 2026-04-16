import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/lang.dart';
import '../../theme/app_colors.dart';
import 'help_logic.dart';

const String _kHelpEn = '''
Welcome to Rice Cake Slideshow Studio. This build keeps all content on your device.

Start on the Discover tab to browse featured works. Tap Create to pick a life-event template, then follow the flow to add photos or short clips, captions, and music when those steps are available.

Works and drafts live under Profile. Statistics summarize local counts only. Use the star row on a work detail screen to add it to My Favorites on this device.

If a screen feels crowded, scroll or collapse panels—every list uses lightweight layouts to avoid overflow.
''';

class HelpView extends GetView<HelpLogic> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Lang.helpTitle, style: TextStyle(fontSize: 18.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Lang.helpBodyTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            Text(
              _kHelpEn,
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
