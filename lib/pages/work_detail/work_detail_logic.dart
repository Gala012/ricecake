import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';
import '../home/featured_list_logic.dart';
import '../home/home_logic.dart';
import '../profile/profile_logic.dart';
import '../ranking/ranking_logic.dart';

class WorkDetailLogic extends GetxController {
  WorkDetailLogic({required this.id});

  final String id;
  final Rxn<WorkRecord> item = Rxn<WorkRecord>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    item.value = await DbRiceCakeHelper.instance.getWork(id);
  }

  void openPreview() {
    final WorkRecord? w = item.value;
    if (w == null || w.slides.isEmpty) return;
    Get.toNamed('/preview_export', parameters: <String, String>{'workId': w.id});
  }

  void openEditFlow() {
    final WorkRecord? w = item.value;
    if (w == null) return;
    if (w.slides.isEmpty) {
      Get.toNamed('/pick_media', parameters: <String, String>{'workId': w.id});
    } else {
      Get.toNamed('/edit_workbench', parameters: <String, String>{'workId': w.id});
    }
  }

  Future<void> toggleFavorite() async {
    final WorkRecord? w = item.value;
    if (w == null) return;
    final WorkRecord next = w.copyWith(
      isFavorite: !w.isFavorite,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await DbRiceCakeHelper.instance.saveWork(next);
    item.value = next;
    if (Get.isRegistered<HomeLogic>()) {
      await Get.find<HomeLogic>().refreshLocal();
    }
    if (Get.isRegistered<FeaturedListLogic>()) {
      await Get.find<FeaturedListLogic>().reload();
    }
    if (Get.isRegistered<RankingLogic>()) {
      await Get.find<RankingLogic>().reload();
    }
    if (Get.isRegistered<ProfileLogic>()) {
      await Get.find<ProfileLogic>().reloadStats();
    }
  }
}
