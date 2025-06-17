import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/view/store/announcement2.dart';
import 'package:ondam_app/vm/notice_controller_firebase.dart';

class Announcement extends StatelessWidget {

Announcement({super.key});
  final noticecontroller = Get.find<Noticecontroller>();
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    noticecontroller.loadNotice();
    return Scaffold(
      backgroundColor:  Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0.5,
        title:  Text("공지사항", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: backgroundColor),
      ),
      body: Obx(
        () => ListView.builder(
          padding:  EdgeInsets.all(16),
          itemCount: noticecontroller.notice.length,
          itemBuilder: (context, index) {
            final notice = noticecontroller.notice[index];
            return Card(
              color: backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              margin:  EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: () => Get.to(
                  () => Announcement2(),
                  arguments: [notice.title, notice.content],
                ),
                title: Text(
                  notice.state == 0 ? "[일반] ${notice.title}" : "[중요] ${notice.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: notice.state == 0 ? Colors.black87 : Colors.redAccent,
                  ),
                ),
                subtitle: Text(
                  "${notice.timeStamp.month}월 ${notice.timeStamp.day}일",
                  style:  TextStyle(color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

} // class