import 'package:get/get.dart';

import '../create/create_logic.dart';
import '../home/home_logic.dart';
import '../profile/profile_logic.dart';
import 'main_shell_logic.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellLogic>(MainShellLogic.new);
    Get.lazyPut<HomeLogic>(HomeLogic.new);
    Get.lazyPut<CreateLogic>(CreateLogic.new);
    Get.lazyPut<ProfileLogic>(ProfileLogic.new);
  }
}
