import 'package:get/get.dart';

import 'edit_workbench_logic.dart';

class EditWorkbenchBinding extends Bindings {
  @override
  void dependencies() {
    final String workId = Get.parameters['workId'] ?? '';
    Get.lazyPut<EditWorkbenchLogic>(() => EditWorkbenchLogic(workId: workId));
  }
}
