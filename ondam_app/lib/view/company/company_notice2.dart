import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/vm/notice_controller_firebase.dart';

class CompanyNotice2 extends StatelessWidget {
  CompanyNotice2({super.key});

  final noticedetailview = Get.find<Noticecontroller>();

  @override
  Widget build(BuildContext context) {
    var value = Get.arguments ?? "__";
    final String title = value[0];
    final String content = value[1];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("공지사항", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding:  EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, 
              style:  TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.grey, 
              thickness: 1.5, 
              height: 20,
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}