import 'package:get/get.dart';

import '../profile/profile_logic.dart';

class MainShellLogic extends GetxController {
  final RxInt tabIndex = 0.obs;

  void setTab(int i) {
    tabIndex.value = i;
    if (i == 2 && Get.isRegistered<ProfileLogic>()) {
      Get.find<ProfileLogic>().reloadStats();
    }
  }
}
