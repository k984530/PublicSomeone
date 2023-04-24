import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static late SharedPreferences pref;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static RxString token = ''.obs;
  static RxBool send = false.obs;
  static RxBool authOk = false.obs;
  static RxString verifyID = "".obs;
  static TextEditingController phone = TextEditingController();
  static TextEditingController authCode = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    FirebaseMessaging.instance.getToken().then(
      (value) {
        token.value = value!;
      },
    );
    SharedPreferences.getInstance().then(
      (value) {
        pref = value;
        if (pref.getString("myPhone") != null) {
          PicksController.myPhone.value = pref.getString("myPhone") as String;
          if (PicksController.myPhone.value == '+821000000000' ||
              PicksController.myPhone.value == '+821000000001') {
            ContactController.test.value = true;
          }
          Get.put(ContactController());
        } else {
          Get.offAndToNamed("/Privacy");
        }
      },
    );
  }

  static RemoveAccount() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(PicksController.myPhone.value)
        .delete();
    await SharedPreferences.getInstance().then(
      (value) {
        value.clear();
      },
    );
    send = false.obs;
    authOk = false.obs;
    verifyID = "".obs;
    phone = TextEditingController();
    authCode = TextEditingController();
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
