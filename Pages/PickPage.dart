import 'dart:io';
import 'dart:math';
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:Someone/Datas/Purchase.dart';
import 'package:Someone/Datas/Questions.dart';
import 'package:Someone/Pages/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PickPage extends StatefulWidget {
  PickPage({super.key});

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  int backInt = Random().nextInt(SomeoneBackgroundcolorList.length);
  @override
  Widget build(BuildContext context) {
    final quetions = Get.put(QuestionsController());
    final firebase = Get.put(FirebaseController());
    final people = Get.put(ContactController());
    final pick = Get.put(PicksController());
    final FCM = Get.put(FCMController());
    Get.put(PurchaseController());
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.notifications,
          size: 35,
          color: SomeoneBackgroundcolorList[backInt],
        ),
        onPressed: () {
          Get.toNamed("/Selected");
        },
      ),
      backgroundColor: SomeoneBackgroundcolorList[backInt],
      drawer: SomeoneDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/QuetionBlock');
              },
              child: Icon(
                Icons.person_off,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<PurchaseController>(builder: (_) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<QuestionsController>(builder: (controller) {
                return Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            QuestionsController.Quetion.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (PicksController.chance.value > 0 &&
                                    PicksController.loading.value &&
                                    ContactController.first.value != '') {
                                  PicksController.loading.value = false;
                                  pick.sendData(
                                    QuestionsController.Quetion.value,
                                    ContactController.first.value,
                                    ContactController.firstPhone.value,
                                  );
                                  quetions.randValue();
                                  ContactController.selectPeople();
                                  if (PicksController.chance.value ==
                                      PicksController.maxChance.value) {
                                    pick.FirstPick();
                                  }
                                  setState(() {
                                    PicksController.chance.value -= 1;
                                    backInt = Random().nextInt(
                                        SomeoneBackgroundcolorList.length);
                                  });
                                } else if (!PicksController.loading.value) {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '데이터를 저장하고 있습니다. 잠시 후 시도해주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                } else if (ContactController.first.value !=
                                    '') {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '사용 가능 횟수가 없습니다 기다려주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(25, 10, 10, 10),
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: SomeoneAnswerBoxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    ContactController.first.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (PicksController.chance.value > 0 &&
                                    PicksController.loading.value &&
                                    ContactController.second.value != '') {
                                  PicksController.loading.value = false;
                                  pick.sendData(
                                    QuestionsController.Quetion.value,
                                    ContactController.second.value,
                                    ContactController.secondPhone.value,
                                  );
                                  quetions.randValue();
                                  ContactController.selectPeople();
                                  if (PicksController.chance.value ==
                                      PicksController.maxChance.value) {
                                    pick.FirstPick();
                                  } else {
                                    pick.Pick();
                                  }
                                  setState(() {
                                    backInt = Random().nextInt(
                                        SomeoneBackgroundcolorList.length);
                                  });
                                } else if (!PicksController.loading.value) {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '데이터를 저장하고 있습니다. 잠시 후 시도해주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                } else if (ContactController.second.value !=
                                    '') {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '사용 가능 횟수가 없습니다 기다려주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 25, 10),
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: SomeoneAnswerBoxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    ContactController.second.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (PicksController.chance.value > 0 &&
                                    PicksController.loading.value &&
                                    ContactController.third.value != '') {
                                  PicksController.loading.value = false;
                                  pick.sendData(
                                    QuestionsController.Quetion.value,
                                    ContactController.third.value,
                                    ContactController.thirdPhone.value,
                                  );
                                  quetions.randValue();
                                  ContactController.selectPeople();
                                  if (PicksController.chance.value ==
                                      PicksController.maxChance.value) {
                                    pick.FirstPick();
                                  } else {
                                    pick.Pick();
                                  }
                                  setState(() {
                                    backInt = Random().nextInt(
                                        SomeoneBackgroundcolorList.length);
                                  });
                                } else if (!PicksController.loading.value) {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '데이터를 저장하고 있습니다. 잠시 후 시도해주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                } else if (ContactController.third.value !=
                                    '') {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '사용 가능 횟수가 없습니다 기다려주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(25, 10, 10, 10),
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: SomeoneAnswerBoxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    ContactController.third.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (PicksController.chance.value > 0 &&
                                    PicksController.loading.value &&
                                    ContactController.fourth.value != '') {
                                  PicksController.loading.value = false;
                                  pick.sendData(
                                    QuestionsController.Quetion.value,
                                    ContactController.fourth.value,
                                    ContactController.fourthPhone.value,
                                  );
                                  quetions.randValue();
                                  ContactController.selectPeople();
                                  if (PicksController.chance.value ==
                                      PicksController.maxChance.value) {
                                    pick.FirstPick();
                                  } else {
                                    pick.Pick();
                                  }
                                  setState(() {
                                    backInt = Random().nextInt(
                                        SomeoneBackgroundcolorList.length);
                                  });
                                } else if (!PicksController.loading.value) {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '데이터를 저장하고 있습니다. 잠시 후 시도해주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                } else if (ContactController.fourth.value !=
                                    '') {
                                  Get.closeAllSnackbars();
                                  Get.snackbar(
                                    'Someone',
                                    '사용 가능 횟수가 없습니다 기다려주세요.',
                                    duration: Duration(milliseconds: 1500),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 25, 10),
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: SomeoneAnswerBoxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    ContactController.fourth.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          if (PicksController.chance.value > 0 &&
                              PicksController.loading.value) {
                            quetions.randValue();
                            ContactController.selectPeople();
                            if (PicksController.chance.value ==
                                PicksController.maxChance.value) {
                              pick.FirstPick();
                            } else {
                              pick.Pick();
                            }
                            setState(
                              () {
                                backInt = Random()
                                    .nextInt(SomeoneBackgroundcolorList.length);
                              },
                            );
                          } else if (!PicksController.loading.value) {
                            Get.closeAllSnackbars();
                            Get.snackbar(
                              'Someone',
                              '데이터를 저장하고 있습니다. 잠시 후 시도해주세요.',
                              duration: Duration(milliseconds: 1500),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                            );
                          } else {
                            Get.closeAllSnackbars();
                            Get.snackbar(
                              'Someone',
                              '사용 가능 횟수가 없습니다 기다려주세요.',
                              duration: Duration(milliseconds: 1500),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Text(
                            "SKIP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GetBuilder<PicksController>(
                        builder: (controller) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              PicksController.chance.value > 0
                                  ? PicksController.chance.value.toString() +
                                      ' / ' +
                                      PicksController.maxChance.value.toString()
                                  : controller.min.toString() +
                                      " : " +
                                      controller.sec.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
