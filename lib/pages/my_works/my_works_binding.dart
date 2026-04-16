import 'package:get/get.dart';

import 'my_works_logic.dart';

class MyWorksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyWorksLogic>(MyWorksLogic.new);
  }
}
