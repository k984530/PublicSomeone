import 'package:Someone/Datas/Constant.dart';
import 'package:Someone/Datas/Contacts.dart';
import 'package:Someone/Datas/Firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AnswerBlockPage extends StatelessWidget {
  const AnswerBlockPage({super.key});

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
          return ContactController.answerBlocks.length > 0
              ? ListView.builder(
                  itemCount: ContactController.answerBlocks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        controller.Unblock(
                            ContactController.answerBlocks[index]);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                        height: 60,
                        decoration: BoxDecoration(
                          color: SomeoneAnswerBoxColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Text(ContactController
                                .answerBlocks[index].displayName!),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "차단한 사람이 없습니다.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
