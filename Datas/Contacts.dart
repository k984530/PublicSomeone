import 'dart:math';
import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactController extends GetxController {
  static RxList<Contact> contacts = <Contact>[].obs;
  static RxList<Contact> quetionBlocks = <Contact>[].obs;
  static RxList<Contact> answerBlocks = <Contact>[].obs;
  static RxList<Contact> pickList = <Contact>[].obs;
  static Map<dynamic, dynamic> phones = {};
  static Map<dynamic, dynamic> pickPhones = {};
  static RxList<String> blockPhones = <String>[].obs;
  static RxList<dynamic> answerBlockPhones = <dynamic>[].obs;
  static List<int> people = <int>[].obs;
  static RxString first = "".obs;
  static RxString firstPhone = "".obs;
  static RxString second = "".obs;
  static RxString secondPhone = "".obs;
  static RxString third = "".obs;
  static RxString thirdPhone = "".obs;
  static RxString fourth = "".obs;
  static RxString fourthPhone = "".obs;
  static RxBool flag = true.obs;
  static RxBool test = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchContact();
  }

  static fetchContact() async {
    if (ContactController.test.value) {
      contacts.add(Contact(
          displayName: '010-0000-0000 Contact',
          phones: [Item(label: '0', value: '+821000000000')]));
      contacts.add(Contact(
          displayName: '010-0000-0001 Contact',
          phones: [Item(label: '1', value: '+821000000001')]));
      contacts.add(Contact(
          displayName: '010-0000-0002 Contact',
          phones: [Item(label: '2', value: '+821000000002')]));
      contacts.add(Contact(
          displayName: '010-0000-0003 Contact',
          phones: [Item(label: '3', value: '+821000000003')]));
      phones['+821000000000'] = '010-0000-0000 Contact';
      phones['+821000000001'] = '010-0000-0001 Contact';
      phones['+821000000002'] = '010-0000-0002 Contact';
      phones['+821000000003'] = '010-0000-0003 Contact';
      AuthController.authOk.value = true;
      pickList = <Contact>[].obs;
      pickList.addAll(contacts);
      people = [];
      for (final data in quetionBlocks) {
        pickList.remove(data);
      }
      for (int i = 0; i < pickList.length; i++) {
        people.add(i);
      }
      selectPeople();
      Get.offAndToNamed('/Pick');
    } else {
      Permission.contacts.status.then(
        (status) {
          if (!status.isGranted) {
            Permission.contacts.request().then(
              (value) async {
                if (value.isGranted) {
                  ContactsService.getContacts().then(
                    (value) {
                      contacts.value = value;
                      RefinePickList();
                      for (Contact e in contacts) {
                        phones[changePhone(e.phones![0].value as String)] =
                            e.displayName;
                      }
                      GetQuetionBlockList();
                      if (!AuthController.authOk.value) {
                        AuthController.authOk.value = true;
                        Get.offAndToNamed('/Pick');
                      }
                    },
                  );
                }
              },
            );
          } else {
            ContactsService.getContacts().then(
              (value) {
                contacts.value = value;
                RefinePickList();
                for (Contact e in contacts) {
                  phones[changePhone(e.phones![0].value as String)] =
                      e.displayName;
                }
                GetQuetionBlockList();
                if (!AuthController.authOk.value) {
                  AuthController.authOk.value = true;
                  Get.offAndToNamed('/Pick');
                }
              },
            );
          }
        },
      );
    }
  }

  static RefinePickList() {
    contacts.removeWhere((data) =>
        data.phones == null ||
        data.phones!.isEmpty ||
        data.displayName == null ||
        data.displayName!.isEmpty ||
        changePhone(data.phones![0].value as String) == "");
    contacts.sort(
      (a, b) => a.displayName!.compareTo(b.displayName!),
    );
    pickList = <Contact>[].obs;
    pickList.addAll(contacts);
    people = [];
    for (final data in quetionBlocks) {
      pickList.remove(data);
    }

    for (int i = 0; i < pickList.length; i++) {
      people.add(i);
    }
    selectPeople();
  }

  BlockContact(Contact c) {
    if (quetionBlocks.contains(c)) {
      quetionBlocks.remove(c);
    } else {
      quetionBlocks.add(c);
    }
    SharedPreferences.getInstance().then(
      (value) {
        try {
          blockPhones.value = [];
          for (Contact e in quetionBlocks) {
            if (e.phones != null &&
                e.phones!.isNotEmpty &&
                changePhone(e.phones![0].value as String) != "") {
              blockPhones.add(changePhone(e.phones![0].value as String));
            }
          }
        } catch (e) {}
        value.setStringList('QuetionBlock', blockPhones);
        RefinePickList();
      },
    );
    update();
  }

  Unblock(Contact c) {
    answerBlocks.remove(c);
    answerBlockPhones.remove(changePhone(c.phones![0].value!));
    final db = FirebaseController.db;
    try {
      db.collection('User').doc(PicksController.myPhone.value).update(
        {
          'block': answerBlockPhones,
        },
      );
      update();
    } catch (e) {}
  }

  static GetQuetionBlockList() {
    SharedPreferences.getInstance().then(
      (value) {
        try {
          quetionBlocks.value = [];
          blockPhones.value = value.getStringList('QuetionBlock') ?? [];
          for (String p in blockPhones) {
            for (Contact c in contacts) {
              if (c.phones != null && changePhone(c.phones![0].value!) == p) {
                quetionBlocks.add(c);
              }
            }
          }
        } catch (e) {}
      },
    );
  }

  static selectPeople() {
    int len = pickList.length;
    people.shuffle();
    if (len == 0) {
      first.value = '';
      firstPhone.value = '';
      second.value = '';
      third.value = '';
      fourth.value = '';
      secondPhone.value = '';
      thirdPhone.value = '';
      fourthPhone.value = '';
    } else if (len == 1) {
      first.value = pickList[people[0]].displayName!;
      firstPhone.value = changePhone(pickList[people[0]].phones![0].value!);
      second.value = '';
      secondPhone.value = '';
      third.value = '';
      fourth.value = '';
      thirdPhone.value = '';
      fourthPhone.value = '';
    } else if (len == 2) {
      first.value = pickList[people[0]].displayName!;
      second.value = pickList[people[1]].displayName!;
      firstPhone.value = changePhone(pickList[people[0]].phones![0].value!);
      secondPhone.value = changePhone(pickList[people[1]].phones![0].value!);
      third.value = '';
      thirdPhone.value = '';
      fourth.value = '';
      fourthPhone.value = '';
    } else if (len == 3) {
      first.value = pickList[people[0]].displayName!;
      second.value = pickList[people[1]].displayName!;
      third.value = pickList[people[2]].displayName!;
      firstPhone.value = changePhone(pickList[people[0]].phones![0].value!);
      secondPhone.value = changePhone(pickList[people[1]].phones![0].value!);
      thirdPhone.value = changePhone(pickList[people[2]].phones![0].value!);
      fourth.value = '';
      fourthPhone.value = '';
    } else {
      first.value = pickList[people[0]].displayName!;
      second.value = pickList[people[1]].displayName!;
      third.value = pickList[people[2]].displayName!;
      fourth.value = pickList[people[3]].displayName!;
      firstPhone.value = changePhone(pickList[people[0]].phones![0].value!);
      secondPhone.value = changePhone(pickList[people[1]].phones![0].value!);
      thirdPhone.value = changePhone(pickList[people[2]].phones![0].value!);
      fourthPhone.value = changePhone(pickList[people[3]].phones![0].value!);
    }
    try {
      pickPhones = {};
      for (Contact e in pickList) {
        pickPhones[changePhone(e.phones![0].value as String)] = e.displayName;
      }
    } catch (e) {}
  }
}

String changePhone(String s) {
  String str = s.replaceAll(RegExp('[^0-9+]'), "");
  if (str.substring(0, 3) == "+82" && str.length == 13) {
  } else if (str.substring(0, 3) == "010") {
    str = "+8210" + str.substring(3);
  } else {
    str = "";
  }
  return str;
}
