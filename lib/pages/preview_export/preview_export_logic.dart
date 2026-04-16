import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class PreviewExportLogic extends GetxController {
  PreviewExportLogic({required this.workId});

  final String workId;
  late final PageController pageController;
  WorkRecord? work;
  Timer? _timer;
  int pageIndex = 0;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    if (workId.isEmpty) {
      Future<void>.microtask(Get.back<void>);
      return;
    }
    _load();
  }

  void setPageIndex(int i) {
    pageIndex = i;
    update();
  }

  Future<void> _load() async {
    work = await DbRiceCakeHelper.instance.getWork(workId);
    update();
    _timer?.cancel();
    final int n = work?.slides.length ?? 0;
    if (n > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (work == null || work!.slides.length <= 1) return;
        final int next = (pageIndex + 1) % work!.slides.length;
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
