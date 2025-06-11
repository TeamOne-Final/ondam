// 대리점 메인 페이지
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/view/store/announcement.dart';
import 'package:ondam_app/view/store/store_pos/pos_main.dart';
import 'package:ondam_app/view/store/store_user/table_select.dart';

class StoreMain extends StatelessWidget {
  StoreMain({super.key});

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    String managerId = '';
    String companyCode = '';
    managerId = box.read('mid') ?? 'Unknown';
    companyCode = box.read('companyCode') ?? 'Unknown';
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
      appBar: AppBar(title: Text('대리점 메인 페이지'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, $companyCode 대리점 $managerId 님!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => PosMain());
                  },
                  child: Text('포스기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => TableSelect());
                  },
                  child: Text('테이블 설정'),
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
