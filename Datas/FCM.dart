import 'dart:convert';

import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:Someone/Datas/PickDatas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FCMController extends GetxController {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static late NotificationSettings settings;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static late NotificationDetails platformChannelSpecifics;

  @override
  void onInit() {
    super.onInit();
    requestPermission();
    initInfo();
  }

  void requestPermission() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  initInfo() async {
    var androidInitialize = AndroidInitializationSettings('icon_notification');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'onedb',
        'onedb',
        icon: 'icon_notification',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        channelShowBadge: false,
        enableVibration: true,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      );
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  static sendPushMessage(String token, String body, String title) async {
    if (token != '') {
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
                'id': PicksController.myPhone.value,
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": "onedb"
              },
              "to": token,
            },
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}
