import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:Someone/Datas/Questions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController extends GetxController {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static List<Map<dynamic, dynamic>> dataList = [];
  static RxBool state = true.obs;
  static late final listener;

  @override
  void onInit() async {
    super.onInit();
    await getData();
    GetToken();
  }

  static sendData(PicksController p) async {
    try {
      db.collection('User').doc(p.yourPhone.value).get().then(
        (value) {
          if (value.exists) {
            if (!value['block'].contains(
              PicksController.myPhone.value,
            )) {
              db.collection('User').doc(p.yourPhone.value).update(
                {
                  "selected": FieldValue.arrayUnion(
                    [
                      {
                        "phone": PicksController.myPhone.value,
                        "quetion": p.quetion.value,
                      }
                    ],
                  ),
                },
              ).then(
                (_) {
                  final okList = value['ok'] as List<dynamic>;
                  if (okList.contains(PicksController.myPhone.value)) {
                    if (value['notify']) {
                      FCMController.sendPushMessage(
                          value["token"], "누군가 당신을 선택했습니다!", "Someone");
                    }
                    Future.delayed(Duration(seconds: 1), () {
                      PicksController.loading.value = true;
                    });
                  } else {
                    db.collection('User').doc(p.yourPhone.value).update(
                      {
                        "waiting": FieldValue.arrayUnion(
                          [
                            PicksController.myPhone.value,
                          ],
                        )
                      },
                    ).then((value) {
                      Future.delayed(Duration(seconds: 1), () {
                        PicksController.loading.value = true;
                      });
                    });
                  }
                },
              );
            }
          } else {
            Future.delayed(Duration(seconds: 1), () {
              PicksController.loading.value = true;
            });
          }
        },
      );
    } catch (e) {
      Future.delayed(Duration(seconds: 1), () {
        PicksController.loading.value = true;
      });
    }
  }

  Future<void> NotifyChange() async {
    state.value = !state.value;
    db.collection('User').doc(PicksController.myPhone.value).update(
      {
        "notify": state.value,
      },
    );
    update();
  }

  Future<void> getData() async {
    listener = db
        .collection('User')
        .doc(PicksController.myPhone.value)
        .snapshots(includeMetadataChanges: true)
        .listen(
      (event) {
        if (!event.exists) {
          CreateDB();
        } else {
          final data = event.data();
          GetSelectedData(data!);
          state.value = data['notify'];
          WaitingData(data);
          GetAnswerBlockList(data);
        }
      },
    );
  }

  void CreateDB() {
    db.collection('User').doc(PicksController.myPhone.value).set(
      {
        'block': [],
        'notify': true,
        'token': AuthController.token.value,
        'ok': [],
        'waiting': [],
        'selected': [],
      },
      SetOptions(merge: true),
    );
  }

  void GetSelectedData(Map<String, dynamic> data) {
    dataList = [];
    for (Map m in data['selected']) {
      if (ContactController.phones.containsKey(m['phone'])) {
        dataList.add(
          {
            'phone': m['phone'],
            'person': ContactController.phones[m['phone']],
            'quetion': m['quetion']
          },
        );
      }
    }
  }

  void blockPerson(int index) {
    db
        .collection('User')
        .doc(
          PicksController.myPhone.value,
        )
        .update(
      {
        'block': FieldValue.arrayUnion([dataList[index]['phone']]),
      },
    );
    update();
  }

  GetAnswerBlockList(Map<String, dynamic> data) {
    ContactController.answerBlockPhones.value = data['block'];
    for (String p in ContactController.answerBlockPhones) {
      for (Contact c in ContactController.contacts) {
        if (changePhone(c.phones![0].value!) == p) {
          ContactController.answerBlocks.add(c);
        }
      }
    }
    update();
  }

  void deleteData(int index) {
    dataList.removeAt(index);
    var impList = dataList.map(
      (e) => {
        'phone': e['phone'],
        'quetion': e['quetion'],
      },
    );
    impList = impList.toList();
    db.collection('User').doc(PicksController.myPhone.value).update(
      {
        'selected': impList,
      },
    );
    update();
  }

  void WaitingData(Map<String, dynamic> data) {
    final waitingList = data['waiting'] as List<dynamic>;
    if (waitingList.isNotEmpty) {
      for (final wait in waitingList) {
        if (ContactController.phones.keys.contains(wait)) {
          FCMController.sendPushMessage(
              AuthController.token.value, "누군가 당신을 선택했습니다!", "Someone");
          db.collection('User').doc(PicksController.myPhone.value).update(
            {
              "ok": FieldValue.arrayUnion(
                [wait],
              ),
              "waiting": [],
            },
          );
        }
      }
    }
  }

  void GetToken() async {
    await db
        .collection('User')
        .doc(PicksController.myPhone.value)
        .get()
        .then((data) {
      if (AuthController.token.value != data['token']) {
        FirebaseController.db
            .collection('User')
            .doc(PicksController.myPhone.value)
            .update(
          {
            'token': AuthController.token.value,
          },
        );
      }
    });
  }
}
