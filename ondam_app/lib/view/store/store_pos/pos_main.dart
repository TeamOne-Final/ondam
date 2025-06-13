import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/model/movingobject.dart';
import 'package:ondam_app/view/store/pos_orderhistory.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_tab.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class PosMain extends StatelessWidget {
  PosMain({super.key});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VmHandlerTemp());
    String managerId = '';
    String companyCode = '';
    managerId = box.read('mid') ?? 'Unknown';
    companyCode = box.read('companyCode') ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: Text('카운터 메인화면')),
      drawer: Drawer(
        // 왼쪽에 Drawer 추가
        child: ListView(
          // Drawer 내부에 항목들을 배치하기 위해 ListView 사용
          padding: EdgeInsets.zero, // 상단 패딩 제거
          children: [
            DrawerHeader(
              // Drawer 상단 헤더
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                '$managerId님',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              // 내비게이션 항목 1
              leading: Icon(Icons.home),
              title: Text('카운터 홈'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              // 내비게이션 항목 2
              leading: Icon(Icons.find_in_page),
              title: Text('결제 내역'),
              onTap: () {
                Get.to(()=> Posorderhistory());
                // 항목 탭 시 실행될 동작
                // Navigator.pop(context); // Drawer 닫기
              },
            ),
            Divider(), // 구분선
            ListTile(
              // 설정 항목
              leading: Icon(Icons.bar_chart),
              title: Text('매출 리포트'),
              onTap: () {
                controller.selectedStoreReportProductIndex.value=1;
                Get.to(() => StoreProductTab());
                // 항목 탭 시 실행될 동작
                // Navigator.pop(context); // Drawer 닫기
              },
            ),
            ListTile(
              // 설정 항목
              leading: Icon(Icons.production_quantity_limits),
              title: Text('상품 관리'),
              onTap: () {
                controller.selectedStoreReportProductIndex.value=0;
                Get.to(() => StoreProductTab());
                // 항목 탭 시 실행될 동작
                // Navigator.pop(context); // Drawer 닫기
              },
            ),
            ListTile(
              // 설정 항목
              leading: Icon(Icons.pin),
              title: Text('재고 관리'),
              onTap: () {
                // 항목 탭 시 실행될 동작
                // Navigator.pop(context); // Drawer 닫기
              },
            ),
            ListTile(
              // 설정 항목
              leading: Icon(Icons.logout),
              title: Text('메인 화면'),
              onTap: () {
                Get.to(() => StoreMain());
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        // 로딩 중일 때 로딩 인디케이터 표시
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // 불러온 데이터가 없을 때 메시지 표시
        else if (controller.loadedObjects.isEmpty) {
          return Center(child: Text('저장된 데이터가 없습니다.'));
        }
        // 데이터가 있을 때 객체들을 화면에 표시
        else {
          return Stack(
            children:
                controller.loadedObjects.map((obj) {
                  // Positioned 위젯을 사용하여 불러온 좌표에 객체 배치
                  return Positioned(
                    left: obj.xCoordinate,
                    top: obj.yCoordinate,
                    child: GestureDetector(
                      onTap: () {
                        _paying(obj.tableNum);
                      },
                      child: Container(
                        // MovingObject에서 정의한 객체 크기 재사용
                        width: MovingObject.objectWidth,
                        height: MovingObject.objectHeight,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          // 객체 중앙에 tableNum 표시
                          child: Text(
                            obj.tableNum.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(), // Map 결과를 List로 변환
          );
        }
      }),
    );
  }

  _paying(int tableNum) {
    Get.defaultDialog(
      title: '$tableNum번 테이블',
      content: Text('data'),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('취소')),
      actions: [
        TextButton(
          onPressed: () {
            //
          },
          child: Text('결제하기'),
        ),
      ],
    );
  }
}
