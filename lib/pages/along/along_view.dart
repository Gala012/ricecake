import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'along_logic.dart';

class AlongView extends GetView<AlongLogic> {
  const AlongView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.lfcgmde.value
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.xjknoiv();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
