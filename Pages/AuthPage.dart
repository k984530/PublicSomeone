import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: GetBuilder<AuthController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: TextField(
                        cursorColor: Colors.white,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          hintText: "010-0000-0000",
                          border: InputBorder.none,
                        ),
                        controller: AuthController.phone,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, //숫자만!
                          NumberFormatter(), // 자동하이픈
                          LengthLimitingTextInputFormatter(
                              13) //13자리만 입력받도록 하이픈 2개+숫자 11개
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (AuthController.phone.text.length == 13) {
                          Get.closeAllSnackbars();
                          Get.snackbar(
                            '사용자 인증',
                            '인증 번호를 보냈습니다. 시간이 조금 소요되니 기다려주세요.',
                            duration: Duration(milliseconds: 1500),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                          );
                          try {
                            AuthController.send.value = true;
                            controller.update();
                            await AuthController.auth.verifyPhoneNumber(
                              phoneNumber: '+8210' +
                                  AuthController.phone.text.substring(4, 8) +
                                  AuthController.phone.text.substring(9),
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                AuthController.pref
                                    .setString(
                                  "myPhone",
                                  '+8210' +
                                      AuthController.phone.text
                                          .substring(4, 8) +
                                      AuthController.phone.text.substring(9),
                                )
                                    .then((value) async {
                                  PicksController.myPhone.value =
                                      AuthController.pref.getString("myPhone")
                                          as String;
                                  if (PicksController.myPhone.value ==
                                          '+821000000000' ||
                                      PicksController.myPhone.value ==
                                          '+821000000001') {
                                    ContactController.test.value = true;
                                  }
                                  Get.offNamed("/GetData");
                                  await ContactController.fetchContact();
                                });
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                Get.snackbar(
                                  '사용자 인증',
                                  '너무 많은 요청을 보냈습니다.\n60분 뒤에 재시도해주십시요. 죄송합니다.',
                                  duration: Duration(milliseconds: 2500),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                );
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                AuthController.verifyID.value = verificationId;
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } catch (e) {}
                        } else {
                          Get.closeAllSnackbars();
                          Get.snackbar(
                            '사용자 인증',
                            '입력 양식을 맞춰주세요 010-0000-0000',
                            duration: Duration(milliseconds: 1500),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        child: Text(
                          AuthController.send.value ? "다시 보내기" : "인증 번호 보내기",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (AuthController.send.value)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 100,
                        margin: EdgeInsets.only(
                            top: 10,
                            right: MediaQuery.of(context).size.width * 0.22),
                        child: TextField(
                          cursorColor: Colors.white,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          controller: AuthController.authCode,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AuthController.auth
                              .signInWithCredential(
                            PhoneAuthProvider.credential(
                              verificationId:
                                  AuthController.verifyID.value.trim(),
                              smsCode: AuthController.authCode.text.trim(),
                            ),
                          )
                              .then(
                            (value) {
                              if (value.user?.phoneNumber != null) {
                                AuthController.pref
                                    .setString(
                                  "myPhone",
                                  '+8210' +
                                      AuthController.phone.text
                                          .substring(4, 8) +
                                      AuthController.phone.text.substring(9),
                                )
                                    .then(
                                  (value) {
                                    PicksController.myPhone.value =
                                        AuthController.pref.getString("myPhone")
                                            as String;
                                    if (PicksController.myPhone.value ==
                                            '+821000000000' ||
                                        PicksController.myPhone.value ==
                                            '+821000000001') {
                                      ContactController.test.value = true;
                                    }
                                    Get.offNamed("/GetData");
                                    Get.put(ContactController());
                                  },
                                );
                              }
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          color: Colors.white.withOpacity(0),
                          child: Text(
                            "확인하기",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
