import 'package:get/get.dart';

import 'pick_media_logic.dart';

class PickMediaBinding extends Bindings {
  @override
  void dependencies() {
    final String workId = Get.parameters['workId'] ?? '';
    Get.lazyPut<PickMediaLogic>(() => PickMediaLogic(workId: workId));
  }
}
