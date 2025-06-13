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
      backgroundColor:   Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor:   Color(0xFFEFEFEF),
        elevation: 2,
        title:   Text(" 공지사항", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => addshow(),
            icon:  Icon(Icons.add_circle_rounded, color: Colors.black, size: 28),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding:   EdgeInsets.all(16),
          itemCount: noticecontroller.notice.length,
          itemBuilder: (context, index) {
            final notice = noticecontroller.notice[index];
            return Container(
              margin:  EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset:  Offset(4, 4),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset:  Offset(-4, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                onTap: () => Get.to(() => CompanyNotice2(), arguments: [notice.title, notice.content]),
                title: Text(
                  notice.state == 0 ? notice.title : " [중요] ${notice.title}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: notice.state == 0 ? Colors.black87 : Colors.redAccent,
                  ),
                ),
                subtitle: Padding(
                  padding:   EdgeInsets.only(top: 8),
                  child: Text(
                    "${notice.timeStamp.month}월 ${notice.timeStamp.day}일",
                    style:   TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon:  Icon(Icons.more_vert),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child:   Text("삭제", style: TextStyle(color: Colors.white)),
                        ),
                        cancel: TextButton(
                          onPressed: () => Get.back(),
                          child:   Text("취소"),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) =>  [
                    PopupMenuItem(value: 'edit', child: Text('✏️ 수정')),
                    PopupMenuItem(value: 'delete', child: Text('🗑️ 삭제')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void addshow() {
    int selectedType = 0;
    titleTextController.clear();
    contentTextController.clear();
    Get.defaultDialog(
      title: "공지 추가",
      content: buildDialogContent(selectedType, isUpdate: false),
    );
  }

  void updateshow(notice) {
    int selectedType = notice.state;
    titleTextController.text = notice.title;
    contentTextController.text = notice.content;
    Get.defaultDialog(
      title: "공지 수정",
      content: buildDialogContent(selectedType, isUpdate: true, notice: notice),
    );
  }

  Widget buildDialogContent(int selectedType, {required bool isUpdate, dynamic notice}) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: StatefulBuilder(
      builder: (context, setState) {
        final double dialogWidth = 700;
        final double dialogHeight = 600;
    
        return SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding:   EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleTextController,
                    style:   TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "제목",
                      hintText: "공지 제목을 입력하세요",
                      labelStyle:  TextStyle(fontSize: 18),
                      hintStyle:   TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: contentTextController,
                    style:   TextStyle(fontSize: 18),
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "내용",
                      hintText: "공지 내용을 입력하세요",
                      labelStyle:  TextStyle(fontSize: 18),
                      hintStyle:   TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                    
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: selectedType,
                        onChanged: (value) => setState(() => selectedType = value!),
                      ),
                      Text("중요", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                      SizedBox(width: 40),
                      Radio<int>(
                        value: 0,
                        groupValue: selectedType,
                        onChanged: (value) => setState(() => selectedType = value!),
                      ),
                      Text("일반", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 32),
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
                      backgroundColor: const Color.fromARGB(255, 234, 240, 236),
                      minimumSize:   Size(200, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle:   TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      elevation: 8,
                    ),
                    child: Text(isUpdate ? "수정하기" : "추가하기"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}}