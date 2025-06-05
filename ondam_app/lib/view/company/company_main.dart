// 본사 메인
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/widget/admin_side_menu.dart';

class CompanyMain extends StatelessWidget {
  const CompanyMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          AdminSideMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                  child: Text('본사 사장', style: TextStyle(fontSize: 40),),
                ),
                Row(
                  children: [
                    _buildContainer(context, '총 매장 수', 'N개'),
                    _buildContainer(context, '일자 총 매출', '1,234,000원'),
                    _buildContainer(context, '오늘 주문', 'N건'),
                    _buildContainer(context, '이슈', 'N건'),
                  ],
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
                    Obx(() => 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 15, 15, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width/1.37,
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        // child: DataTable(
                        //   columns: [
                        //     DataColumn(label: Text('매장명')),
                        //   ], 
                        //   rows: DataRow(cells: [
                        //     DataCell(Text('data'))
                        //   ]);
                        // ),
                      ),
                    ),
                    ) 
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