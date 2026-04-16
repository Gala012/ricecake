import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class RankingLogic extends GetxController {
  final RxList<WorkRecord> ranked = <WorkRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    final List<WorkRecord> list = await DbRiceCakeHelper.instance.listWorks(
      isDraft: false,
      favoriteOnly: true,
      orderBy: 'updated_at DESC',
    );
    ranked.assignAll(list);
  }
}
