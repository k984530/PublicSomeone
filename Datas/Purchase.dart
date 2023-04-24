import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseController extends GetxController {
  static RxBool subscribe = false.obs;
  void onInit() async {
    super.onInit();
    Purchases.addCustomerInfoUpdateListener(
      (_) => updateCustomerStatus(),
    );
    Purchases.logIn(secure(PicksController.myPhone.value)).then((account) {
      Purchases.getCustomerInfo().then(
        (value) {
          subscribe.value = value.entitlements.active['User'] != null;
          if (subscribe.value) {
            PicksController.chance.value = 50;
            PicksController.maxChance.value = 50;
          }
          update();
        },
      );
    });
  }

  String secure(String p) {
    String id = p;
    for (int i = 0; i < 10; i++) {
      id = id.replaceAll(i.toString(), secure_key[i.toString()]!);
    }
    return id;
  }

  Future updateCustomerStatus() async {
    Purchases.getCustomerInfo().then(
      (value) {
        if (value.entitlements.active['User'] != null) {
          if (PicksController.chance.value == 30) {
            PicksController.chance.value += 20;
            PicksController.maxChance.value += 20;
          }
          PurchaseController.subscribe.value = true;
        }
        update();
      },
    );
  }

  void purchase() async {
    try {
      if (Platform.isIOS) {
        await Purchases.purchaseProduct('someone_m1');
      } else if (Platform.isAndroid) {
        await Purchases.purchaseProduct('someone_sub');
      }
    } catch (e) {
      debugPrint('상품을 구매하는데 실패하였습니다');
    }
  }
}
