import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class MyWorksLogic extends GetxController {
  final RxList<WorkRecord> items = <WorkRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    final List<WorkRecord> list =
        await DbRiceCakeHelper.instance.listWorks(isDraft: false, orderBy: 'updated_at DESC');
    items.assignAll(list);
  }
}
