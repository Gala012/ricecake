import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class FeaturedListLogic extends GetxController {
  final RxList<WorkRecord> items = <WorkRecord>[].obs;
  final RxList<WorkRecord> all = <WorkRecord>[].obs;
  final RxList<String> tagOptions = <String>[].obs;
  final RxInt sort = 0.obs;
  final RxnString tagFilter = RxnString();

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    final List<WorkRecord> list = await DbRiceCakeHelper.instance.listWorks(isDraft: false);
    all.assignAll(list);
    tagOptions.assignAll(await DbRiceCakeHelper.instance.distinctPublishedTags());
    _apply();
  }

  void setSort(int i) {
    sort.value = i;
    _apply();
  }

  void setTag(String? t) {
    tagFilter.value = t;
    _apply();
  }

  void _apply() {
    List<WorkRecord> list = List<WorkRecord>.from(all);
    final String? tf = tagFilter.value;
    if (tf != null && tf.isNotEmpty) {
      list = list.where((WorkRecord e) => e.tag == tf).toList();
    }
    if (sort.value == 0) {
      list.sort((WorkRecord a, WorkRecord b) {
        if (a.isFavorite != b.isFavorite) {
          return a.isFavorite ? -1 : 1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
    } else {
      list.sort((WorkRecord a, WorkRecord b) => b.createdAt.compareTo(a.createdAt));
    }
    items.assignAll(list);
  }
}
