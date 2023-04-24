import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:Someone/Datas/Questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GetDataPage extends StatelessWidget {
  const GetDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () async {
            Permission.contacts.status.then((status) async {
              if (status.isGranted) {
                await ContactController.fetchContact();
              } else {
                openAppSettings();
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: MediaQuery.of(context).size.height * 0.12,
                image: AssetImage('lib/image/someone.png'),
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'S O M E O N E',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '연락처 접근 권한을 허용해주세요\n터치 시 권한 설정으로 이동합니다.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
