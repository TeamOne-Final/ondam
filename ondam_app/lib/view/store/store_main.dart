// 대리점 메인 페이지
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/view/login.dart';
import 'package:ondam_app/view/store/announcement.dart';
import 'package:ondam_app/view/store/store_pos/pos_main.dart';
import 'package:ondam_app/view/store/store_user/create_table.dart';
import 'package:ondam_app/view/store/store_user/table_select.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class StoreMain extends StatelessWidget {
  StoreMain({super.key});

  final box = GetStorage();
  final controller = Get.put(VmHandlerTemp());
  @override
  Widget build(BuildContext context) {
    String managerId = '';
    String companyCode = '';
    managerId = box.read('mid') ?? 'Unknown';
    companyCode = box.read('companyCode') ?? 'Unknown';
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
      appBar: AppBar(
        title: Text(
          '안녕하세요, $companyCode 대리점 $managerId 님!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => Login()),
            icon: Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.fetchObjects(companyCode);
                    Get.to(() => PosMain());
                  },
                  child: Text('포스기'),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => CreateTable());
                      },
                      child: Text('테이블 배치'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.fetchObjects(companyCode);
                        Get.to(() => TableSelect());
                      },
                      child: Text('테이블 설정'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => Announcement());
                  },
                  child: Text('공지 사항'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
