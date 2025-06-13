import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StoreProductAnalysis extends StatelessWidget {
  StoreProductAnalysis({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  final _formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.productAnalysisForTotalList.isEmpty) {
            return Center(child: Text('데이터가 없습니다.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '상품 분석',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: ListTile(
                              title: Text('시작 날짜'),
                              subtitle: Text(
                                controller.firstDate.value.isEmpty
                                    ? '선택된 날짜 없음'
                                    : controller.firstDate.value,
                              ),
                              trailing: Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                              onTap: () async {
                                final now = DateTime.now();
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: now,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                  locale: Locale('ko', 'KR'),
                                );
                                if (picked != null) {
                                  controller.firstDate.value = _formatter.format(
                                    picked,
                                  );
                                  controller.selectEachStoreFirstToFinal('강남');
                                  controller.purchaseSituationData('강남');
                                  controller.purchaseSituationChart('강남');
                                  controller.productAnalysisChart('강남');
                                  controller.productAnalysisTotal('강남');
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: ListTile(
                              title: Text('종료 날짜'),
                              subtitle: Text(
                                controller.firstDate.value.isEmpty
                                    ? '선택된 날짜 없음'
                                    : controller.finalDate.value,
                              ),
                              trailing: Icon(
                                Icons.calendar_today,
                                color: Colors.red,
                              ),
                              onTap: () async {
                                final initial =
                                    controller.firstDate.value.isNotEmpty
                                        ? _formatter.parse(
                                          controller.firstDate.value,
                                        )
                                        : DateTime.now();
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: initial,
                                  firstDate: initial,
                                  lastDate: DateTime(2100),
                                  locale: Locale('ko', 'KR'),
                                );
                                if (picked != null) {
                                  controller.finalDate.value = _formatter.format(
                                    picked,
                                  );
                                  controller.selectEachStoreFirstToFinal('강남');
                                  controller.purchaseSituationData('강남');
                                  controller.purchaseSituationChart('강남');
                                  controller.productAnalysisChart('강남');
                                  controller.productAnalysisTotal('강남');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('총 판매 금액 : ', style: TextStyle(fontSize: 20)),
                                Text(
                                  '${controller.productAnalysisForTotalList[0].totalPrice}원',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('총 판매 개수 : ', style: TextStyle(fontSize: 20)),
                                Text(
                                  '${controller.productAnalysisForTotalList[0].quantity}건',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                  Text('Best 상품', style: TextStyle(fontSize: 30)),
                  SfCircularChart(
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      overflowMode: LegendItemOverflowMode.wrap,
                      // legendItemBuilder로 각 항목 레이아웃 커스텀
                      legendItemBuilder: (
                        String name,
                        dynamic series,
                        dynamic point,
                        int index,
                      ) {
                        final total = controller.productAnalysisForChartList
                            .fold<int>(
                              0,
                              (sum, item) => sum + (item.quantity ?? 0),
                            );
                        final qty = point.y as int; // yValue값
                        final percent =
                            total == 0 ? 0 : ((qty / total) * 100).round();
        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: point.color, // 범례 아이콘 색
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('$name $qty개 ($percent%)'),
                          ],
                        );
                      },
                    ),
                    series: <CircularSeries<Chart, String>>[
                      PieSeries<Chart, String>(
                        dataSource: controller.productAnalysisForChartList,
                        xValueMapper: (data, _) => data.menuName,
                        yValueMapper: (data, _) => data.quantity,
                        dataLabelSettings: DataLabelSettings(isVisible: false),
                        enableTooltip: true,
                      ),
                    ],
                  ),
                  DataTable(
                    columnSpacing: 200,
                    columns: [
                      DataColumn(label: Text('순위')),
                      DataColumn(label: Text('상품')),
                      DataColumn(label: Text('판매 금액')),
                      DataColumn(label: Text('판매 개수')),
                    ],
                    rows: List.generate(
                      controller.productAnalysisForChartList.length,
                      (index) {
                        var store = controller.productAnalysisForChartList[index];
                        return DataRow(
                          cells: [
                            DataCell(Text('${(index + 1).toString()}위')), // 순번
                            DataCell(Text(store.menuName!)),
                            DataCell(Text(store.totalPrice.toString())),
                            DataCell(Text(store.quantity.toString())),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
