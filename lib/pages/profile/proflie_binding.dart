import 'package:get/get.dart';
import 'package:rice_cake/pages/profile/profile_logic.dart';


class MyWorksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileLogic>(ProfileLogic.new);
  }
}
