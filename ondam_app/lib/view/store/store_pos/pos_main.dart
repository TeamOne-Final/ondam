import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/view/store/pos_orderhistory.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_tab.dart';
import 'package:ondam_app/vm/chat_controller_firebase.dart';
import 'package:ondam_app/vm/message_controller_firebase.dart';
import 'package:ondam_app/vm/vm2handelr.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/widget/tableorderdialogcontent.dart';

class PosMain extends StatelessWidget {
  PosMain({super.key});
  final message = Get.find<Messagecontroller>();
  final chatroom = Get.find<Chatcontroller>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VmHandlerTemp>();
    final vmHandler = Get.find<Vm2handelr>();
    String managerId = box.read('mid') ?? '';
    String companyCode = box.read('companyCode') ?? 'Unknown';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchObjects(companyCode);
    });

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('카운터 화면',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: mainColor,
        foregroundColor: backgroundColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Obx(() => _buildBody(controller, vmHandler, companyCode)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainColor,mainColor.withAlpha(150)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    '$managerId님',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, '카운터 홈', () => Get.back()),
            _buildDrawerItem(
              Icons.find_in_page,
              '결제 내역',
              () => Get.to(() => Posorderhistory()),
            ),
            Divider(),
            _buildDrawerItem(Icons.bar_chart, '매출 리포트', () {
              controller.selectedStoreReportProductIndex.value = 1;
              Get.to(() => StoreProductTab());
            }),
            // _buildDrawerItem(Icons.production_quantity_limits, '상품 관리', () {
            //   controller.selectedStoreReportProductIndex.value = 0;
            //   Get.to(() => StoreProductTab());
            // }),
            _buildDrawerItem(
              Icons.logout,
              '메인 화면',
              () => Get.to(() => StoreMain()),
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
      return Container(
        color: Colors.grey.shade100,
        child: Stack(
          children:
              controller.loadedObjects.map((obj) {
                return Positioned(
                  left: obj.xCoordinate,
                  top: obj.yCoordinate,
                  child: InkWell(
                    onTap: () {
                      _showTableOrderDialog(
                        vmHandler,
                        obj.tableNum.toString(),
                        companyCode,
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: mainColor,
                      elevation: 4,
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: Text(
                          obj.tableNum.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    }
  }

  void _showTableOrderDialog(
    Vm2handelr vmHandler,
    String tableNum,
    String companyCode,
  ) {
    vmHandler.fetchTableOrderItems(tableNum, companyCode);

    Get.defaultDialog(
      title: '$tableNum 번 테이블 주문 내역',
      content: TableOrderDialogContent(
        vmHandler: vmHandler,
        tableNum: tableNum,
      ),
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      backgroundColor: Colors.white,
      radius: 8,
      actions: [
        ElevatedButton.icon(
          icon: Icon(Icons.payment,color: Colors.white,),
          label: Text('결제하기',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: () async{
            vmHandler.updateOrderStateToCompleted(tableNum, companyCode);
            await chatroom.deleteAllChatroomsOfMember(tableNum);    // 채팅방 삭제 
            Get.back();
          },
        ),
        OutlinedButton(
          child: Text('닫기',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: mainColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
