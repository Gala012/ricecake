import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../lang/lang.dart';
import '../../models/slide_item.dart';
import '../../models/work_record.dart';
import '../../utils/media_storage.dart';

class PickMediaLogic extends GetxController {
  PickMediaLogic({required this.workId});

  final String workId;
  final RxList<SlideItem> slides = <SlideItem>[].obs;
  final Rxn<WorkRecord> work = Rxn<WorkRecord>();

  @override
  void onInit() {
    super.onInit();
    if (workId.isEmpty) {
      Future<void>.microtask(() {
        Get.back<void>();
        Get.snackbar(Lang.createTitle, Lang.errorMissingWork);
      });
      return;
    }
    _load();
  }

  Future<void> _load() async {
    final w = await DbRiceCakeHelper.instance.getWork(workId);
    work.value = w;
    if (w != null) slides.assignAll(w.slides);
  }

  Future<void> pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> files = <XFile>[];
    try {
      files = await picker.pickMultiImage(imageQuality: 88);
    } on PlatformException catch (e) {
      final bool channelBroken = e.code == 'channel-error' ||
          (e.message ?? '').contains('Unable to establish connection on channel');
      if (channelBroken) {
        try {
          final XFile? one = await picker.pickImage(source: ImageSource.gallery, imageQuality: 88);
          if (one != null) {
            files = <XFile>[one];
            Get.snackbar(Lang.pickMediaTitle, Lang.pickMediaSingleFallback, duration: const Duration(seconds: 3));
          }
        } on PlatformException {
          Get.snackbar(Lang.pickMediaTitle, Lang.pickMediaPlatformError, duration: const Duration(seconds: 4));
        }
      } else {
        Get.snackbar(Lang.pickMediaTitle, Lang.pickMediaPlatformError, duration: const Duration(seconds: 4));
      }
    }
    if (files.isEmpty) return;
    for (final XFile x in files) {
      final String path = await MediaStorage.copyPickToWorkDir(workId, x.path, suggestedName: x.name);
      slides.add(SlideItem(path: path));
    }
    await _persistSlides();
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= slides.length) return;
    slides.removeAt(index);
    await _persistSlides();
  }

  Future<void> _persistSlides() async {
    final WorkRecord? w = await DbRiceCakeHelper.instance.getWork(workId);
    if (w == null) return;
    final String? cover = slides.isEmpty ? null : slides.first.path;
    final WorkRecord next = w.copyWith(
      slides: List<SlideItem>.from(slides),
      coverPath: cover,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await DbRiceCakeHelper.instance.saveWork(next);
    work.value = next;
  }

  Future<void> goEdit() async {
    if (slides.isEmpty) {
      Get.snackbar(Lang.createTitle, Lang.pickMediaNeedOne);
      return;
    }
    await Get.offNamed('/edit_workbench', parameters: <String, String>{'workId': workId});
  }
}
