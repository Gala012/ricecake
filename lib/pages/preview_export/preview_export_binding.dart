import 'package:get/get.dart';

import 'preview_export_logic.dart';

class PreviewExportBinding extends Bindings {
  @override
  void dependencies() {
    final String workId = Get.parameters['workId'] ?? '';
    Get.lazyPut<PreviewExportLogic>(() => PreviewExportLogic(workId: workId));
  }
}
