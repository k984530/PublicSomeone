import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  static late List<dynamic> contacts;
  static RxString Quetion = "".obs;
  int index = 0;

  @override
  void onInit() async {
    super.onInit();
    await GetData();
  }

  GetData() {
    FirebaseFirestore.instance
        .collection('Quetions')
        .doc('Quetions')
        .get()
        .then((value) {
      contacts = value['Quetion'];
      update();
      randValue();
    });
  }

  randValue() {
    int num = Random().nextInt(contacts.length);
    while (num == index) {
      num = Random().nextInt(contacts.length);
    }
    index = num;
    Quetion.value = contacts[index].toString().replaceAll(r'\n', '\n');
    update();
  }
}
