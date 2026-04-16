import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../lang/lang.dart';
import '../../models/slide_item.dart';
import '../../models/work_record.dart';
import '../home/featured_list_logic.dart';
import '../home/home_logic.dart';
import '../profile/profile_logic.dart';

class EditWorkbenchLogic extends GetxController {
  EditWorkbenchLogic({required this.workId});

  final String workId;
  final TextEditingController titleController = TextEditingController();
  final List<TextEditingController> captionControllers = <TextEditingController>[];
  WorkRecord? work;

  @override
  void onInit() {
    super.onInit();
    if (workId.isEmpty) {
      Future<void>.microtask(Get.back<void>);
      return;
    }
    _load();
  }

  Future<void> _load() async {
    final WorkRecord? w = await DbRiceCakeHelper.instance.getWork(workId);
    work = w;
    _rebuildCaptionControllers(w);
    update();
  }

  void _rebuildCaptionControllers(WorkRecord? w) {
    for (final TextEditingController c in captionControllers) {
      c.dispose();
    }
    captionControllers.clear();
    if (w == null) return;
    titleController.text = w.title;
    for (final SlideItem s in w.slides) {
      captionControllers.add(TextEditingController(text: s.caption));
    }
  }

  Future<void> saveDraft() async {
    await _persist(markPublished: false);
    Get.back<void>();
  }

  Future<void> saveChanges() async {
    await _persist(markPublished: true);
    update();
    if (Get.isRegistered<HomeLogic>()) {
      await Get.find<HomeLogic>().refreshLocal();
    }
    if (Get.isRegistered<ProfileLogic>()) {
      await Get.find<ProfileLogic>().reloadStats();
    }
    if (Get.isRegistered<FeaturedListLogic>()) {
      await Get.find<FeaturedListLogic>().reload();
    }
    Get.snackbar(
      Lang.editWorkbenchTitle,
      Lang.editSaveDone,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _persist({bool markPublished = false}) async {
    final WorkRecord? w = await DbRiceCakeHelper.instance.getWork(workId);
    if (w == null) return;
    while (captionControllers.length < w.slides.length) {
      captionControllers.add(TextEditingController());
    }
    while (captionControllers.length > w.slides.length) {
      captionControllers.removeLast().dispose();
    }
    final List<SlideItem> nextSlides = <SlideItem>[];
    for (int i = 0; i < w.slides.length; i++) {
      final String cap = i < captionControllers.length ? captionControllers[i].text : '';
      nextSlides.add(SlideItem(path: w.slides[i].path, caption: cap));
    }
    final String t = titleController.text.trim().isEmpty ? w.title : titleController.text.trim();
    final WorkRecord next = w.copyWith(
      title: t,
      slides: nextSlides,
      coverPath: nextSlides.isEmpty ? null : nextSlides.first.path,
      isDraft: markPublished ? false : w.isDraft,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await DbRiceCakeHelper.instance.saveWork(next);
    work = next;
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    for (final TextEditingController c in captionControllers) {
      c.dispose();
    }
    captionControllers.clear();
    super.onClose();
  }
}
