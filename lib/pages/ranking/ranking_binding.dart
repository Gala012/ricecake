import 'package:get/get.dart';

import 'ranking_logic.dart';

class RankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankingLogic>(RankingLogic.new);
  }
}
