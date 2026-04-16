import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class HomeLogic extends GetxController {
  final RxList<WorkRecord> featured = <WorkRecord>[].obs;
  final RxList<WorkRecord> recentDrafts = <WorkRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshLocal();
  }

  Future<void> refreshLocal() async {
    final List<WorkRecord> list = await DbRiceCakeHelper.instance.listWorks(
      isDraft: false,
      limit: 12,
      orderBy: 'is_favorite DESC, created_at DESC',
    );
    featured.assignAll(list);
    final List<WorkRecord> drafts = await DbRiceCakeHelper.instance.listWorks(
      isDraft: true,
      limit: 10,
      orderBy: 'updated_at DESC',
    );
    recentDrafts.assignAll(drafts);
  }
}
