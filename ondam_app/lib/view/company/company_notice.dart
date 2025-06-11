// 공지사항 메인
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/view/company/company_notice2.dart';
import 'package:ondam_app/vm/notice_controller_firebase.dart';

class CompanyNotice extends StatelessWidget {
  CompanyNotice({super.key});
  final noticecontroller = Get.find<Noticecontroller>();
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    noticecontroller.loadNotice();
    return Scaffold(
      backgroundColor:  Color(0xFFF7F7F9),
      appBar: AppBar(
        elevation: 0.5,
        title:  Text("공지사항", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () => addshow(),
            icon:  Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding:  EdgeInsets.all(16),
          itemCount: noticecontroller.notice.length,
          itemBuilder: (context, index) {
            final notice = noticecontroller.notice[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              margin:  EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: () => Get.to(
                  () =>CompanyNotice2(),
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
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      updateshow(notice);
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: "삭제 확인",
                        middleText: "정말로 삭제하시겠습니까?",
                        confirm: ElevatedButton(
                          onPressed: () {
                            noticecontroller.deleteNotice(notice.noticeId);
                            Get.back();
                          },
                          child:  Text("확인"),
                        ),
                        cancel: TextButton(
                          onPressed: () => Get.back(),
                          child:  Text("취소"),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('수정'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('삭제'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  addshow() {
    int selectedType = 0;
    Get.defaultDialog(
      title: "공지 추가",
      content: buildDialogContent(selectedType, isUpdate: false),
    );
  }

  updateshow(notice) {
    int selectedType = notice.state;
    contentTextController.text = notice.content;
    titleTextController.text = notice.title;
    Get.defaultDialog(
      title: "공지 수정",
      content: buildDialogContent(selectedType, isUpdate: true, notice: notice),
    );
  }

  Widget buildDialogContent(int selectedType, {required bool isUpdate, dynamic notice}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleTextController,
                decoration:  InputDecoration(
                  labelText: "제목",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentTextController,
                maxLines: 6,
                decoration:  InputDecoration(
                  labelText: "내용",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<int>(
                    value: 1,
                    groupValue: selectedType,
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  Text("중요"),
                  Radio<int>(
                    value: 0,
                    groupValue: selectedType,
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  Text("일반"),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (isUpdate) {
                    noticecontroller.updateNotice(
                      notice.noticeId,
                      titleTextController.text,
                      contentTextController.text,
                      selectedType,
                    );
                  } else {
                    noticecontroller.createNotice(
                      titleTextController.text,
                      contentTextController.text,
                      selectedType,
                    );
                  }
                  titleTextController.clear();
                  contentTextController.clear();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(isUpdate ? "수정하기" : "추가하기"),
              ),
            ],
          ),
        );
      },
    );
  }
} // class