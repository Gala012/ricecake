import 'package:get/get.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';
import '../../models/work_record.dart';

class StatsLogic extends GetxController {
  final RxInt workCount = 0.obs;
  final RxInt draftCount = 0.obs;
  final RxInt streakDays = 0.obs;
  final RxList<double> weekly = List<double>.filled(7, 0).obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    workCount.value = await DbRiceCakeHelper.instance.countWorks(draft: false);
    draftCount.value = await DbRiceCakeHelper.instance.countWorks(draft: true);
    final List<int> w = await DbRiceCakeHelper.instance.weeklyCreateCounts();
    weekly.assignAll(w.map((int e) => e.toDouble()));
    final List<WorkRecord> works = await DbRiceCakeHelper.instance.listWorks(isDraft: false);
    final Set<DateTime> days = works
        .map((WorkRecord e) => DateTime.fromMillisecondsSinceEpoch(e.createdAt))
        .map((DateTime d) => DateTime(d.year, d.month, d.day))
        .toSet();
    streakDays.value = days.length.clamp(0, 365);
  }
}
