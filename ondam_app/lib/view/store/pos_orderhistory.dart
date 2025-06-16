import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class Posorderhistory extends StatelessWidget {
  Posorderhistory({super.key});

  final VmHandlerTemp posOrderhistroty = Get.find<VmHandlerTemp>();
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title:  Text("결제내역", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Row(
        children: [
          // 좌측 리스트
          Expanded(
            flex: 2,
            child: Obx(() {
              final purchases = posOrderhistroty.purchase;

              // 날짜별로 그룹화
              final Map<String, List> groupedByDate = {};
              for (var p in purchases) {
                final date = p.tranDate.substring(0, 10);
                groupedByDate.putIfAbsent(date, () => []).add(p);
              }

              final dateKeys = groupedByDate.keys.toList();

              return Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.all(12.0),
                    child: TextField(
                      controller: search,
                      decoration: InputDecoration(
                        hintText: "YYYY-MM-DD",
                        prefixIcon:  Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) => posOrderhistroty.loadPurchase("강남", search.text),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dateKeys.length,
                      itemBuilder: (context, dateIndex) {
                        final date = dateKeys[dateIndex];
                        final purchaseList = groupedByDate[date]!;

                        return Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Container(
                            color: backgroundColor,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                color: backgroundColor,
                                child: ExpansionTile(
                                  title: Text(
                                    date,
                                    style:  TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  children: purchaseList.map((p) {
                                    final index = purchases.indexOf(p);
                                    return Container(
                                      color: backgroundColor,
                                      child: ListTile(
                                        title: Text("주문번호: ${p.cartNum}"),
                                        trailing: Text("${p.totalPirce.toStringAsFixed(0)}원"),
                                        selected: posOrderhistroty.selectedIndex.value == index,
                                        selectedTileColor: Colors.indigo.shade50,
                                        onTap: () {
                                          posOrderhistroty.selectedIndex.value = index;
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          // 우측 상세 정보
          Expanded(
            flex: 5,
            child: Padding(
              padding:  EdgeInsets.all(24.0),
              child: Obx(() {
                final index = posOrderhistroty.selectedIndex.value;
                if (posOrderhistroty.purchase.isEmpty) {
                  return  Center(child: Text(" 결제내역이 없습니다."));
                }

                final selected = posOrderhistroty.purchase[index];

                return Card(
                  color: backgroundColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:  EdgeInsets.all(24.0),
                    child: Container(
                      color: backgroundColor,
                      child: ListView(
                        children: [
                          Text(
                            "${selected.userTableCompanyCode} 지점",
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text("거래번호: ${selected.cartNum}", style: theme.textTheme.bodyMedium),
                          Divider(height: 32),
                                        
                          _infoRow("결제시간", selected.tranDate.substring(0, 16)),
                          _infoRow("결제수단", "카드"),
                          _infoRow("총 금액", "${selected.totalPirce.toStringAsFixed(0)}원"),
                                        
                          Divider(height: 32),
                          Text("결제 상세", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                          SizedBox(height: 8),
                                        
                          Container(
                            padding:  EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: backgroundColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(selected.receiptLine, style:  TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                    Spacer(),
                                    Text(selected.salesMenus, textAlign: TextAlign.right,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                                        
                          SizedBox(height: 32),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "총합: ${selected.totalPirce.toStringAsFixed(0)}원",
                              style:  TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style:  TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}