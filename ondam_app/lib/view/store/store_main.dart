// 대리점 메인 페이지 (디자인 개선)
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
    String managerId = box.read('mid') ?? 'Unknown';
    String companyCode = box.read('companyCode') ?? 'Unknown';

    return Scaffold(
      backgroundColor: const Color(0xFF161E28),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          '안녕하세요, $companyCode 대리점 $managerId 님!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => Get.to(() => Login()),
            tooltip: '로그아웃',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _mainButton(
                    label: '포스기',
                    icon: Icons.point_of_sale,
                    onPressed: () {
                      controller.fetchObjects(companyCode);
                      Get.to(() => PosMain());
                    },
                  ),
                  _mainButton(
                    label: '테이블 배치',
                    icon: Icons.table_bar,
                    onPressed: () => Get.to(() => CreateTable()),
                  ),
                  _mainButton(
                    label: '테이블 설정',
                    icon: Icons.settings,
                    onPressed: () {
                      controller.fetchObjects(companyCode);
                      Get.to(() => TableSelect());
                    },
                  ),
                  _mainButton(
                    label: '공지 사항',
                    icon: Icons.announcement,
                    onPressed: () => Get.to(() => Announcement()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
      ),
    );
  }
}
