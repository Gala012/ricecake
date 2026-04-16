import 'package:get/get.dart';

import 'drafts_logic.dart';

class DraftsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DraftsLogic>(DraftsLogic.new);
  }
}
