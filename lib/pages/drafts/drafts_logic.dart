import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';
import '../home/home_logic.dart';
import '../profile/profile_logic.dart';

class DraftsLogic extends GetxController {
  final RxList<WorkRecord> items = <WorkRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    final List<WorkRecord> list =
        await DbRiceCakeHelper.instance.listWorks(isDraft: true, orderBy: 'updated_at DESC');
    items.assignAll(list);
  }

  Future<void> deleteDraft(String id) async {
    await DbRiceCakeHelper.instance.deleteWork(id);
    await reload();
    if (Get.isRegistered<HomeLogic>()) {
      await Get.find<HomeLogic>().refreshLocal();
    }
    if (Get.isRegistered<ProfileLogic>()) {
      await Get.find<ProfileLogic>().reloadStats();
    }
  }
}
