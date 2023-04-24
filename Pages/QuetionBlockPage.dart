import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class QuetionBlockPage extends StatelessWidget {
  const QuetionBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      backgroundColor: SomeoneBackgroundcolor,
      body: GetBuilder<ContactController>(
        init: ContactController(),
        builder: (controller) {
          return ListView.builder(
            itemCount: ContactController.contacts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  controller.BlockContact(ContactController.contacts[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  height: 60,
                  decoration: BoxDecoration(
                    color: ContactController.quetionBlocks
                            .contains(ContactController.contacts[index])
                        ? SomeoneAnswerBoxColor.withOpacity(0.5)
                        : SomeoneAnswerBoxColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                        child: Text(
                            ContactController.contacts[index].displayName!)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
