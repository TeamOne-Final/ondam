// 매출관리
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/view/chart/admin_day_price.dart';
import 'package:ondam_app/view/chart/admin_select_store.dart';
import 'package:ondam_app/view/chart/ondam_menu_total_month.dart';
import 'package:ondam_app/view/chart/ondam_store_price_page.dart';
import 'package:ondam_app/view/chart/ondam_total_price_page.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CompanySales extends StatelessWidget {
  CompanySales({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller.tabController,
        children: [FirstPage(), SecondPage(), ThirdPage(), FourthPage(), SixthPage()]
        ),
        bottomNavigationBar: Obx(
          () => 
          BottomNavigationBar(
            backgroundColor: backgroundColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.tabController.index = index;
            },
            selectedItemColor: mainColor,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart, ), label: '본사 일별 매출'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart,), label: '전체 메뉴 매출'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart, ), label: '대리점 별 전체 매출'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart, ), label: '대리점 년/월별 매출'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart, ), label: '본사 년/월별 매출'),
            ]),
        ),
    );
  }
}