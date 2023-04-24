import 'dart:io';

import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:Someone/Datas/Purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SelectedPage extends StatelessWidget {
  const SelectedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          leading: GetBuilder<FirebaseController>(
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  Get.closeAllSnackbars();
                  Get.snackbar(
                    'Someone',
                    FirebaseController.state.value ? '푸시 알림 OFF' : '푸시 알림 ON',
                    duration: Duration(milliseconds: 1500),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                  );
                  controller.NotifyChange();
                },
                child: Icon(
                  FirebaseController.state.value
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              );
            },
          ),
          actions: [
            if (PurchaseController.subscribe.value)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/AnswerBlock');
                  },
                  child: Icon(
                    Icons.person_off,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              )
          ],
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
        ),
        backgroundColor: SomeoneBackgroundcolor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.back();
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.volunteer_activism,
            color: SomeoneBackgroundcolor,
          ),
        ),
        body: GetBuilder<FirebaseController>(
          init: FirebaseController(),
          builder: (controller) {
            int len = FirebaseController.dataList.length;
            return FirebaseController.dataList.length > 0
                ? ListView.builder(
                    itemCount: len,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          Get.dialog(
                            AlertDialog(
                              content: Text(PurchaseController.subscribe.value
                                  ? '해당 글을 삭제하거나 사용자를 차단하시겠습니까?'
                                  : '해당 글을 삭제하시겠습니까?'),
                              actionsPadding: EdgeInsets.only(
                                right: 20,
                                bottom: 20,
                              ),
                              actions: [
                                GestureDetector(
                                  onTap: () {
                                    controller.deleteData(len - index - 1);
                                    Get.back();
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (PurchaseController.subscribe.value)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.closeAllSnackbars();
                                        Get.snackbar(
                                          'Someone',
                                          '해당 사용자를 차단했습니다.',
                                          duration:
                                              Duration(milliseconds: 1500),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.white,
                                        );
                                        controller.blockPerson(len - index - 1);
                                        Get.back();
                                      },
                                      child: Text(
                                        '차단',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 20),
                          height: 110,
                          decoration: BoxDecoration(
                            color: SomeoneAnswerBoxColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 25, right: 40, top: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  FirebaseController.dataList[len - index - 1]
                                      ['quetion'],
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 25, bottom: 10),
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!PurchaseController.subscribe.value) {
                                      Get.bottomSheet(
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 25,
                                                bottom: 20,
                                              ),
                                              child: Text(
                                                'SOMEONE 해커 모드',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Divider(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              SomeoneSubInfo,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                if (Platform.isIOS) {
                                                  await Purchases
                                                      .purchaseProduct(
                                                          'someone_m1');
                                                } else if (Platform.isAndroid) {
                                                  await Purchases
                                                      .purchaseProduct(
                                                          'someone_sub');
                                                }
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  Platform.isAndroid
                                                      ? '구독하기 - 900KRW/월'
                                                      : '구독하기 - 1,100KRW/월',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        backgroundColor: Colors.indigo[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 0,
                                      );
                                    }
                                  },
                                  child: Text(
                                    PurchaseController.subscribe.value
                                        ? FirebaseController
                                            .dataList[len - index - 1]['person']
                                        : 'SOMEONE',
                                    style: TextStyle(
                                        color:
                                            PurchaseController.subscribe.value
                                                ? Colors.black
                                                : Colors.indigo),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: 'https://linktr.ee/someoneapp'),
                        );
                        Get.closeAllSnackbars();
                        Get.snackbar(
                          'Someone',
                          '다운로드 링크가 클립보드에 저장되었습니다.',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(milliseconds: 1500),
                          backgroundColor: Colors.white,
                        );
                      },
                      child: Text(
                        '아직 선택받은 질문이 없어요\n다른 사람들에게 이 앱을 알려주세요\n터치시 다운로드 URL이 복사됩니다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
          },
        ),
      );
    });
  }
}
