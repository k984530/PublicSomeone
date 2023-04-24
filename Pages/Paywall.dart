import 'dart:io';
import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SomeonePaywall extends StatelessWidget {
  const SomeonePaywall({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  SomeoneSubInfo,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (Platform.isIOS) {
                      await Purchases.purchaseProduct('someone_m1');
                    } else if (Platform.isAndroid) {
                      await Purchases.purchaseProduct('someone_sub');
                    }
                    Get.back();
                  },
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      Platform.isAndroid ? '구매하기 - 900원/월' : '구매하기 - 1,100원/월',
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
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          );
        }
      },
      child: ListTile(
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        leading: Icon(
          Icons.star_rate,
          color: Colors.grey[400],
        ),
        title: Text(
          '해커모드',
          style: TextStyle(
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
