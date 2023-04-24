import 'dart:io';

import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Pages/Paywall.dart';
import 'package:Someone/Datas/Purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SomeoneDrawer extends StatelessWidget {
  const SomeoneDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: MediaQuery.of(context).size.height * 0.12,
            image: AssetImage(
              'lib/image/someone.png',
            ),
            fit: BoxFit.fitHeight,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'S O M E O N E',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            '내가 보는 네 모습, 네가 보는 내 모습',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ListTile(
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Text(
                        WhatIsSomeone,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              );
            },
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            leading: Icon(
              Icons.question_mark,
              color: Colors.grey[400],
            ),
            title: Text(
              'SOMEONE?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: 'https://linktr.ee/someoneapp'),
              );
              Get.closeAllSnackbars();
              Get.snackbar(
                'Someone',
                '다운로드 링크가 클립보드에 저장되었습니다.',
                duration: Duration(milliseconds: 1500),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
              );
            },
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            leading: Icon(
              Icons.people_alt,
              color: Colors.grey[400],
            ),
            title: Text(
              '친구에게 알려주기',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: 'someoneappdev@gmail.com'),
                        );
                        Get.closeAllSnackbars();
                        Get.snackbar('Someone', '이메일 주소가 클립보드에 저장되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            overlayColor: Colors.amber);
                      },
                      child: Text(
                        '질문 제안 / 문의 \n\nsomeoneappdev@gmail.com\n\n터치시 클립보드에 저장됩니다.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            leading: Icon(
              Icons.send,
              color: Colors.grey[400],
            ),
            title: Text(
              '질문 제안 / 문의',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Text(
                        SomeoneAppServiceTermsOfUse,
                      ),
                    ),
                  ),
                ),
              );
            },
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            leading: Icon(
              Icons.article,
              color: Colors.grey[400],
            ),
            title: Text(
              '서비스 이용약관',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            SomeoneInfoUse,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    height: 250,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Text(
                                          '계정을 삭제하시겠습니까?\n\n사내 DB에 저장된 정보가 삭제되며\n복구할 수 없습니다.\n구독은 별도로 스토어에서\n구독 취소하셔야 합니다.',
                                          textAlign: TextAlign.center,
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                FirebaseController.listener
                                                    .cancel();
                                                await AuthController
                                                    .RemoveAccount();
                                                Get.offAllNamed('/Privacy');
                                              },
                                              child: Text(
                                                '삭제',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                '아니요',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '회원 탈퇴',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            leading: Icon(
              Icons.mobile_friendly,
              color: Colors.grey[400],
            ),
            title: Text(
              '개인정보 처리방침',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          if (!PurchaseController.subscribe.value) SomeonePaywall(),
        ],
      ),
    );
  }
}
