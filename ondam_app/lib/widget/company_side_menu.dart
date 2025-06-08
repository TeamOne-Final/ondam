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

class CompanySideMenu extends StatelessWidget {
  const CompanySideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.find<VmHandlerTemp>();
    return Container(
      width: MediaQuery.sizeOf(context).width/5,
      decoration: BoxDecoration(color: const Color.fromRGBO(46, 61, 83, 1)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text('DASHBOARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTile(vmHandler, 0, Icons.store, '가맹점 관리', () => CompanyMain()),
                _buildTile(vmHandler, 1, Icons.restaurant, '메뉴 관리', () => CompanyItem()),
                _buildTile(vmHandler, 2, Icons.approval, '주문/계약', () => CompanyOrder()),
                _buildTile(vmHandler, 4, Icons.notifications, '공지 사항', () => CompanyNotice()),
                _buildTile(vmHandler, 5, Icons.manage_accounts, '직원 관리', () => CompanyEmployee()),
                _buildTile(vmHandler, 6, Icons.bar_chart, '매출 관리', () => CompanySales()),
                _buildTile(vmHandler, 7, Icons.logout, '로그아웃', () => Login()),
              ],
            ),
          )
        ],
      ),
    );
  } // build

  // Widgets
  Widget _buildTile(SideMenuController vmHandler, int index, IconData icon, String title, Widget Function() page){
    return Obx(() {
      final isSelected = vmHandler.selectedIndex.value == index;

      return Container(
        color: isSelected ? Color(0xFFF6F7FB) : Colors.transparent,
        child: ListTile(
          onTap: () {
            vmHandler.select(index);
            Get.to(page,transition: Transition.noTransition,);
          },
          leading: Icon(icon, color: isSelected ? Colors.black : Colors.white,size: 32),
          title: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
      );
    },);
  }


} // class