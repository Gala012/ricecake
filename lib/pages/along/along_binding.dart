import 'package:get/get.dart';

import 'along_logic.dart';

class AlongBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AlongLogic(),
      permanent: true,
    );
  }
}
