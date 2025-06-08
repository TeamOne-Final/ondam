// 본사 메인
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/widget/company_side_menu.dart';

class CompanyMain extends StatelessWidget {
  CompanyMain({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          CompanySideMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                  child: Text('본사 사장', style: TextStyle(fontSize: 40),),
                ),
                Obx(() => 
                Row(
                  children: [
                    _buildContainer(context, '총 매장 수', '${controller.storeCount.value}개'),
                    _buildContainer(context, '일자 총 매출', '${controller.todaySales.value}원'),
                    _buildContainer(context, '오늘 주문', '${controller.todayOrderCount.value}건'),
                    _buildContainer(context, '이슈', '${controller.storeCount.value}건'),
                  ],
                ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 10, 20),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width/2.8,
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width/2.8,
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 15, 15, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width/1.37,
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('매장명')),
                              DataColumn(label: Text('지역')),
                              DataColumn(label: Text('매니저')),
                              DataColumn(label: Text('전화번호')),
                              DataColumn(label: Text('운영상태')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text('홍길동')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(ElevatedButton(onPressed: () {}, child: Text('Edit'))),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('홍길동')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(Text('개발팀')),
                                DataCell(ElevatedButton(onPressed: () {}, child: Text('Edit'))),
                              ]),
                            ],
                          )
                        )
                      ),
                    ),
              ],
            ),
          )
        ],
      )
    );
  } // build

  // --- Widgets ---
  _buildContainer(BuildContext context, String title, String content){
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
      child: Container(
        width: MediaQuery.sizeOf(context).width/6,
        height: MediaQuery.sizeOf(context).height/10,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
              child: Text(title, style: TextStyle(fontSize: 19),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
              child: Text(content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            )
          ],
        )
      ),
    );
  }



} // class