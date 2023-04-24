import 'dart:io';
import 'package:Someone/Datas/Auth.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/FCM.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:Someone/Pages/AnswerBlockPage.dart';
import 'package:Someone/Pages/AuthPage.dart';
import 'package:Someone/Pages/GetDataPage.dart';
import 'package:Someone/Pages/PickPage.dart';
import 'package:Someone/Pages/PrivacyPage.dart';
import 'package:Someone/Pages/QuetionBlockPage.dart';
import 'package:Someone/Pages/SelectedPage.dart';
import 'package:Someone/Pages/UseInfoPage.dart';
import 'package:Someone/firebase_options.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
  await Purchases.configure(configuration);

  FirebaseMessaging.instance.getInitialMessage().then(
    (value) {
      runApp(
        MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetDataPage(),
      getPages: [
        GetPage(
          name: '/Auth',
          page: () => AuthPage(),
        ),
        GetPage(
          name: '/Privacy',
          page: () => PrivacyPage(),
        ),
        GetPage(
          name: '/Pick',
          page: () => PickPage(),
        ),
        GetPage(
          name: '/Selected',
          page: () => SelectedPage(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: '/GetData',
          page: () => GetDataPage(),
        ),
        GetPage(
          name: '/QuetionBlock',
          page: () => QuetionBlockPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/AnswerBlock',
          page: () => AnswerBlockPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/UseInfo',
          page: () => UseInfoPage(),
        ),
      ],
    );
  }
}
