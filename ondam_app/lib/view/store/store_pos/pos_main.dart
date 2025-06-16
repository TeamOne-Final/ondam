import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/view/store/pos_orderhistory.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_tab.dart';
import 'package:ondam_app/vm/vm2handelr.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/widget/tableorderdialogcontent.dart';

class PosMain extends StatelessWidget {
  PosMain({super.key});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VmHandlerTemp>();
    final vmHandler = Get.find<Vm2handelr>();
    String managerId = "";
    String companyCode = '';
    companyCode = box.read('companyCode') ?? 'Unknown';
    managerId = box.read('mid') ?? '';
    // 페이지 로드 시 테이블 위치 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchObjects(companyCode);
    });

    return Scaffold(
      appBar: AppBar(title: Text('저장된 물체 보기')),
      body: Obx(() => _buildBody(controller, vmHandler, companyCode)),
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
                Get.to(() => Posorderhistory());
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
                controller.selectedStoreReportProductIndex.value = 1;
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
                controller.selectedStoreReportProductIndex.value = 0;
                Get.to(() => StoreProductTab());
                // 항목 탭 시 실행될 동작
                // Navigator.pop(context); // Drawer 닫기
              },
            ),
            // ListTile(
            //   // 설정 항목
            //   leading: Icon(Icons.pin),
            //   title: Text('재고 관리'),
            //   onTap: () {
            //     // 항목 탭 시 실행될 동작
            //     // Navigator.pop(context); // Drawer 닫기
            //   },
            // ),
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
    );
  }

  Widget _buildBody(
    VmHandlerTemp controller,
    Vm2handelr vmHandler,
    String companyCode,
  ) {
    if (controller.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    } else if (controller.loadedObjects.isEmpty) {
      return Center(child: Text('저장된 데이터가 없습니다.'));
    } else {
      return Stack(
        children:
            controller.loadedObjects.map((obj) {
              return Positioned(
                left: obj.xCoordinate,
                top: obj.yCoordinate,
                child: GestureDetector(
                  onTap: () {
                    _showTableOrderDialog(
                      vmHandler,
                      obj.tableNum.toString(),
                      companyCode,
                    );
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Center(
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
            }).toList(),
      );
    }
  }

  // 테이블 주문 내역 다이얼로그를 Get.defaultDialog로 표시하는 함수
  void _showTableOrderDialog(
    Vm2handelr vmHandler,
    String tableNum,
    String companyCode,
  ) {
    // 다이얼로그가 열릴 때 해당 테이블의 주문 내역을 가져옵니다.
    vmHandler.fetchTableOrderItems(
      tableNum,
      companyCode,
    ); // VmHandlerTemp에서 데이터 로딩 시작

    Get.defaultDialog(
      title: '$tableNum 번 테이블 주문 내역',
      // 다이얼로그 내용: 주문 목록 및 총 금액 표시 위젯
      content: TableOrderDialogContent(
        vmHandler: vmHandler,
        tableNum: tableNum,
      ),
      actions: [
        TextButton(
          child: Text('결제하기'),
          onPressed: () {
            vmHandler.updateOrderStateToCompleted(tableNum, companyCode);
            Get.back();
          },
        ),
        TextButton(
          child: Text('닫기'),
          onPressed: () {
            Get.back();
            vmHandler.clearTableOrderItems();
          },
        ),
      ],
      onWillPop: () async {
        vmHandler.clearTableOrderItems();
        return true;
      },
    );
  }
}
