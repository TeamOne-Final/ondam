/*
  2025.06.04 이학현 | 본사 사이드 메뉴 위젯
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/view/company/company_employee.dart';
import 'package:ondam_app/view/company/company_item.dart';
import 'package:ondam_app/view/company/company_main.dart';
import 'package:ondam_app/view/company/company_notice.dart';
import 'package:ondam_app/view/company/company_order.dart';
import 'package:ondam_app/view/company/company_sales.dart';
import 'package:ondam_app/view/login.dart';
import 'package:ondam_app/vm/side_menu_controller.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(color: const Color.fromRGBO(46, 61, 83, 1)),
            child: 
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 30),
                      child: Text('DASHBOARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTile(vmHandler, 0, Icons.store, '가맹점 관리'),
                          _buildTile(vmHandler, 1, Icons.restaurant, '메뉴 관리'),
                          _buildTile(vmHandler, 2, Icons.approval, '주문/계약'),
                          _buildTile(vmHandler, 3, Icons.notifications, '공지 사항'),
                          _buildTile(vmHandler, 4, Icons.manage_accounts, '직원 관리'),
                          _buildTile(vmHandler, 5, Icons.bar_chart, '매출 관리'),
                          _buildTile(vmHandler, 6, Icons.logout, '로그아웃'),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Obx(() {
            switch (vmHandler.selectedIndex.value){
              case 0:
                return CompanyMain();
              case 1:
                return CompanyItem();
              case 2:
                return CompanyOrder();
              case 3:
                return CompanyNotice();
              case 4:
                return CompanyEmployee();
              case 5:
                return CompanySales();
              case 6:
                Future.microtask(() => Get.offAll(() => Login(), transition: Transition.noTransition));
                return SizedBox.shrink();
              default:
                return Center(child: Text('페이지를 선택해 주세요'),);
            }
          },),
        )
      ],
    ) 
    );
  } // build

  // Widgets
  Widget _buildTile(SideMenuController vmHandler, int index, IconData icon, String title){
    return Obx(() {
      final isSelected = vmHandler.selectedIndex.value == index;

      return Container(
        color: isSelected ? Color(0xFFF6F7FB) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListTile(
            onTap: () {
              vmHandler.select(index);
            },
            leading: Icon(icon, color: isSelected ? Colors.black : Colors.white,size: 32),
            title: Text(
              title,
              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
        ),
      );
    },);
  }


} // class