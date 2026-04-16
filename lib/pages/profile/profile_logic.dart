import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';

class ProfileLogic extends GetxController {
  final RxInt publishedCount = 0.obs;
  final RxInt draftCount = 0.obs;
  final RxInt favoriteCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    reloadStats();
  }

  Future<void> reloadStats() async {
    publishedCount.value = await DbRiceCakeHelper.instance.countWorks(draft: false);
    draftCount.value = await DbRiceCakeHelper.instance.countWorks(draft: true);
    favoriteCount.value = await DbRiceCakeHelper.instance.countFavoriteWorks();
  }
}
