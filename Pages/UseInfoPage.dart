import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class UseInfoPage extends StatelessWidget {
  const UseInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                '서비스 이용약관',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Text(SomeoneAppServiceTermsOfUse),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Get.offAndToNamed('/Auth');
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '약관에 동의합니다',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
