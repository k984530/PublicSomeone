import 'dart:async';

import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/Purchase.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicksController extends GetxController {
  static RxString myPhone = "".obs;
  RxString quetion = "".obs;
  RxString person = "".obs;
  RxString yourPhone = "".obs;
  RxInt min = 99.obs;
  RxInt sec = 99.obs;
  static RxBool loading = true.obs;
  static RxInt chance = 0.obs;
  static RxInt maxChance = PurchaseController.subscribe.value ? 35.obs : 30.obs;
  RxInt difTime = 0.obs;
  DateTime firstTime = DateTime.now();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    SharedPreferences.getInstance().then(
      (value) {
        myPhone.value =
            value.getString('myPhone') ?? PicksController.myPhone.value;
        chance.value = value.getInt('chance') ?? maxChance.value;
        update();
        if (chance.value < maxChance.value) {
          firstTime = DateTime.parse(value.getString('time')!);
          Timer.periodic(
            Duration(seconds: 1),
            (timer) {
              int difTime = firstTime.difference(DateTime.now()).inSeconds;
              if (difTime > 0) {
                min.value = difTime ~/ 60;
                sec.value = difTime % 60;
                update();
              } else {
                chance.value = maxChance.value;
                value.setInt('chance', chance.value);
                update();
                timer.cancel();
              }
            },
          );
        }
      },
    );
  }

  void Pick() {
    SharedPreferences.getInstance().then(
      (value) async {
        chance.value -= 1;
        await value.setInt('chance', chance.value);
        update();
      },
    );
  }

  void FirstPick() async {
    firstTime = DateTime.now()
        .add(Duration(minutes: PurchaseController.subscribe.value ? 8 : 10));
    chance.value -= 1;
    update();
    SharedPreferences.getInstance().then(
      (value) async {
        await value.setString('time', firstTime.toString());
        await value.setInt('chance', chance.value);
        Timer.periodic(
          Duration(seconds: 1),
          (timer) async {
            int difTime = firstTime.difference(DateTime.now()).inSeconds;
            if (difTime > 0) {
              min.value = difTime ~/ 60;
              sec.value = difTime % 60;
              update();
            } else {
              chance.value = 30;
              if (PurchaseController.subscribe.value) {
                chance.value += 5;
              }
              await value.setInt('chance', chance.value);
              update();
              timer.cancel();
            }
          },
        );
      },
    );
  }

  void sendData(String q, String p, String y) {
    quetion.value = q;
    person.value = p;
    yourPhone.value = y;
    FirebaseController.sendData(this);
  }
}
