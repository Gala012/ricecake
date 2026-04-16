import 'package:get/get.dart';

import 'work_detail_logic.dart';

class WorkDetailBinding extends Bindings {
  @override
  void dependencies() {
    final id = Get.parameters['id'] ?? '';
    Get.lazyPut<WorkDetailLogic>(() => WorkDetailLogic(id: id));
  }
}
