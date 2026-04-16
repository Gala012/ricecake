import 'package:get/get.dart';

import 'featured_list_logic.dart';

class FeaturedListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeaturedListLogic>(
      () {
        final FeaturedListLogic logic = FeaturedListLogic();
        logic.tagFilter.value = null;
        final String? p = Get.parameters['tag'];
        if (p != null && p.isNotEmpty) {
          logic.tagFilter.value = p;
        }
        return logic;
      },
      fenix: true,
    );
  }
}
