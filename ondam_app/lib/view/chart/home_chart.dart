import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/view/chart/admin_day_price.dart';
import 'package:ondam_app/view/chart/admin_select_store.dart';
import 'package:ondam_app/view/chart/ondam_menu_total_month.dart';
import 'package:ondam_app/view/chart/ondam_store_price_page.dart';
import 'package:ondam_app/view/chart/ondam_total_price_page.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class HomeChart extends StatelessWidget {
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  HomeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: TabBarView(
        controller: controller.tabController,
        children: [FirstPage(), SecondPage(), ThirdPage(), FourthPage(), SixthPage()]
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            fixedColor: backgroundColor,
            backgroundColor: backgroundColor,
            onTap: (index) {
              controller.tabController.index = index;
            },
            selectedItemColor: mainColor,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold
            ),
            unselectedLabelStyle: TextStyle(
              color: backgroundColor
            ),
              selectedIconTheme: IconThemeData(color: mainColor),
              unselectedIconTheme: IconThemeData(color: Colors.black),
              type: BottomNavigationBarType.fixed, // 이거 없으면 자동으로 shifting이 적용됨!
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