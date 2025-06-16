import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/model/purchase_with_product.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StoreSalesDetail extends StatelessWidget {
  StoreSalesDetail({super.key});
  final VmHandlerTemp handler = Get.find<VmHandlerTemp>();
  final _formatter = DateFormat('yyyy-MM-dd');
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(
        () => Padding(
          padding: const EdgeInsets.all(50.0),
          child: SingleChildScrollView(
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
                          child: ListTile(
                          title: Text('시작 날짜',style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                            handler.firstDate.value.isEmpty
                              ? '선택된 날짜 없음'
                              : handler.firstDate.value, style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(Icons.calendar_today,color: Colors.blue),
                          onTap: () async{
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              locale: Locale('ko','KR'),
                              );
                              if(picked != null){
                                handler.firstDate.value = _formatter.format(picked);
                                handler.selectEachStoreFirstToFinal('강남');
                                handler.selectTotalSalesCountsOne('강남');
                              }
                          },
                        ),
                      ),
                        Expanded(
                        child: ListTile(
                          title: Text('종료 날짜',style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                            handler.finalDate.value.isEmpty
                              ? '선택된 날짜 없음'
                              : handler.finalDate.value, style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(Icons.calendar_today,color: Colors.red,),
                          onTap: () async{
                            final initial = handler.firstDate.value.isNotEmpty
                            ? _formatter.parse(handler.firstDate.value)
                            : DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: initial,
                              lastDate: DateTime.now(),
                              locale: Locale('ko','KR'),
                              );
                              if(picked != null){
                                handler.finalDate.value = _formatter.format(picked);
                                handler.selectEachStoreFirstToFinal('강남');
                                handler.selectTotalSalesCountsOne('강남');
                              }
                          },
                        ),
                      ),
                  ],
                  ),
                ),
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        dataRowMinHeight: 48,
                        headingRowHeight: 70,
                        columns: [
                          DataColumn(label: Text('매출 총 액', style: TextStyle(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text('주문 건수', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('환불 금액', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('환불 건수', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: [
                          DataRow(
                          cells: [
                            DataCell(
                            Text('${handler.selectOne[0].totalPrice ?? 0}원', style: TextStyle(fontWeight: FontWeight.w600),),
                            ),
                            DataCell(
                              Text('${handler.selectOne[0].countCartNum ?? 0}건',style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            DataCell(
                              Text('${handler.selectOne[0].refundPrice ?? 0}원',style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            DataCell(
                              Text('${handler.selectOne[0].refundCount ?? 0}원',style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ]
                          ),
                        ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: '기간 별 총 매출액',
                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        tooltipBehavior: tooltipBehavior,
                        legend: Legend(isVisible: true),
                        series: [
                          ColumnSeries<PurchaseWithProductDate, String>(
                            color: mainColor,
                            name: 'Period Total Prices',
                            dataSource: handler.firstToFinalList,
                            xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate!.substring(5,10),
                            yValueMapper: (PurchaseWithProductDate prices, _) => prices.totalPrice,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            enableTooltip: true,)
                        ],
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          title: AxisTitle(text: '매출 액',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                SizedBox(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: '기간 별 누적 총 매출액',
                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        tooltipBehavior: tooltipBehavior,
                        legend: Legend(isVisible: true),
                        series: [
                          LineSeries<PurchaseWithProductDate, String>(
                            color: mainColor,
                            name: 'Cumulative Total Prices',
                            dataSource: handler.firstToFinalList,
                            xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate!.substring(5,10),
                            yValueMapper: (PurchaseWithProductDate cumulative, _) => cumulative.cumulativeTotalPrice,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            enableTooltip: true,)
                        ],
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        primaryYAxis: NumericAxis(
                          plotOffset: 30,
                          title: AxisTitle(text: '누적 매출 액',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: SfCartesianChart(
                        margin: EdgeInsets.all(20),
                        title: ChartTitle(
                          text: '기간 별 누적 총 제품 갯수',
                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        tooltipBehavior: tooltipBehavior,
                        legend: Legend(isVisible: true),
                        series: [
                          LineSeries<PurchaseWithProductDate, String>(
                            color: mainColor,
                            name: 'Cumulative Total Sales Counts',
                            dataSource: handler.firstToFinalList,
                            xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate!.substring(5,10),
                            yValueMapper: (PurchaseWithProductDate cumulative, _) => cumulative.cumulativeSalesCount,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            enableTooltip: true,)
                        ],
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        primaryYAxis: NumericAxis(
                          plotOffset:30,
                          title: AxisTitle(text: '누적 제품 수',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}