import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StoreSalesStatus extends StatelessWidget {
  StoreSalesStatus({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  final _formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (vmHandler.purchaseSituationDataList.isEmpty) {
          return Center(child: Text('data is empty'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '매출 현황',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // ElevatedButton(onPressed: () {
                      
                    // }, child: Text('출력하기'))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text('시작 날짜',style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                              vmHandler.firstDate.value.isEmpty
                                  ? '선택된 날짜 없음'
                                  : vmHandler.firstDate.value,
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                vmHandler.firstDate.value = _formatter.format(
                                  picked
                                );
                                vmHandler.selectEachStoreFirstToFinal('강남');
                                vmHandler.purchaseSituationData('강남');
                                vmHandler.purchaseSituationChart('강남');
                                vmHandler.productAnalysisChart('강남');
                                vmHandler.productAnalysisTotal('강남');
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text('종료 날짜',style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                              vmHandler.firstDate.value.isEmpty
                                  ? '선택된 날짜 없음'
                                  : vmHandler.finalDate.value,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(
                              Icons.calendar_today,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              final initial =
                                  vmHandler.firstDate.value.isNotEmpty
                                      ? _formatter.parse(
                                        vmHandler.firstDate.value,
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
                                vmHandler.finalDate.value = _formatter.format(
                                  picked,
                                );
                                vmHandler.selectEachStoreFirstToFinal('강남');
                                vmHandler.purchaseSituationData('강남');
                                vmHandler.purchaseSituationChart('강남');
                                vmHandler.productAnalysisChart('강남');
                                vmHandler.productAnalysisTotal('강남');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    dataRowMinHeight: 48,
                    headingRowHeight: 70,
                    columns: [
                      DataColumn(label: Text('매출',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('주문건',style: TextStyle(fontWeight: FontWeight.bold)),),
                      DataColumn(label: Text('건당 평균가',style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('반품 금액',style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black
                              ),
                              onPressed: () {
                                vmHandler
                                    .selectedStoreReportProductIndex
                                    .value = 2;
                              },
                              label: Row(
                                children: [
                                  Text(
                                    '${vmHandler.purchaseSituationDataList[0].totalPrice}원',
                                    style: TextStyle(fontWeight: FontWeight.w600)
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${vmHandler.purchaseSituationDataList[0].quantity}',
                              style: TextStyle(fontWeight: FontWeight.w600)
                            ),
                          ),
                          DataCell(
                            vmHandler.purchaseSituationDataList[0].quantity! !=
                                    0
                                ? Text(
                                  '${((vmHandler.purchaseSituationDataList[0].totalPrice)! / (vmHandler.purchaseSituationDataList[0].quantity)!)}원',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                                : Text('0원',style: TextStyle(fontWeight: FontWeight.w600),),
                          ),
                          DataCell(
                            Text(
                              '${vmHandler.purchaseSituationDataList[0].maleNum}원',
                              style: TextStyle(fontWeight: FontWeight.w600)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfCartesianChart(
                    title: ChartTitle(text: ''),
                    tooltipBehavior: tooltipBehavior,
                    legend: Legend(isVisible: true),
                    series: [
                      ColumnSeries<Chart, String>(
                        color: mainColor,
                        name: "지난 기간 매출",
                        dataSource: vmHandler.purchaseSituationChartPreList,
                        xValueMapper: (Chart date, index) => date.tranDate,
                        yValueMapper:
                            (Chart prices, index) => prices.totalPrice,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      ),
                      ColumnSeries<Chart, String>(
                        color: mainColor,
                        name: "선택 기간 매출",
                        dataSource: vmHandler.purchaseSituationChartNowList,
                        xValueMapper: (Chart date, index) => date.tranDate,
                        yValueMapper:
                            (Chart prices, index) => prices.totalPrice,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      ),
                    ],
                    primaryYAxis: NumericAxis(
                      plotOffset: 0,
                      title: AxisTitle(
                        text: '매출 액',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                        text: '날짜(일)',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
