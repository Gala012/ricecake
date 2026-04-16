import 'package:get/get.dart';

import '../../data/mock_content.dart';
import '../../db_rice_cake/db_rice_cake_helper.dart';

class CreateLogic extends GetxController {
  final RxList<String> categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(MockContent.templateCategories());
  }

  Future<void> startWithTag(String tag) async {
    final String id = await DbRiceCakeHelper.instance.createDraftWork(tag: tag);
    await Get.toNamed(
      '/pick_media',
      parameters: <String, String>{'workId': id},
    );
  }
}
