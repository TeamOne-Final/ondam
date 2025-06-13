import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class Posorderhistory extends StatelessWidget {
  Posorderhistory({super.key});

  final VmHandlerTemp posOrderhistroty = Get.find<VmHandlerTemp>();
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("결제내역"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text(DateTime.now().toString())),
          ),
        ],
      ),
      body: Row(
        children: [
          // 좌측 결제내역 리스트
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("날짜선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: search,
                    decoration: InputDecoration(
                      hintText: '주문번호, 카드번호 앞 6자리 등',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(DateTime.now().toString())),
                      Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: posOrderhistroty.purchase.length,
                        itemBuilder: (context, index) {
                          final purchase = posOrderhistroty.purchase[index];
                          return GestureDetector(
                            onTap: () {
                              posOrderhistroty.selectedIndex.value = index;
                            },
                            child: ListTile(
                              title: Text(purchase.tranDate.substring(0, 10)),
                              selected: posOrderhistroty.selectedIndex.value == index,
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          ),

          // 우측 상세 내역
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Obx(() {
                final index = posOrderhistroty.selectedIndex.value;
                if (posOrderhistroty.purchase.isEmpty) {
                  return Center(child: Text("결제내역이 없습니다."));
                }
                final selected = posOrderhistroty.purchase[index];

                return ListView(
                  children: [
                    Text("${selected.userTableCompanyCode}점",style: TextStyle(
                      fontSize: 20
                    ),),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text("거래번호: ${selected.cartNum}번"),
                      ],
                    ),
                    Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("금액"), Text("${selected.cartNumTotalPrice}원")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("결제시간"), Text(selected.tranDate.substring(0, 16))],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("결제수단"), Text("카드")],
                    ),
                    Divider(height: 32),
                    Text("결제내역", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text("${selected.menuName} "), 
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${selected.cartNumTotalPrice}원",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}