import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';

class GuideLogic extends GetxController {
  final PageController pageController = PageController();
  final RxInt pageIndex = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int i) {
    pageIndex.value = i;
  }

  Future<void> finishGuide() async {
    await DbRiceCakeHelper.instance.setSetting('onboarding_done', '1');
    Get.offAllNamed('/main');
  }
}
