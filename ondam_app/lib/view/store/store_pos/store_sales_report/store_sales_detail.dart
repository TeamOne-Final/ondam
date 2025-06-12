import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    handler.selectEachStoreFirstToFinal('강남');
    return Scaffold(
      body:SingleChildScrollView(
        child: Obx(() {
          if(handler.firstToFinalList.isEmpty){
            return Center(child: Text('데이터를 불러오는 중입니다.....'));
          }
          return Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Row(
                children: [
              Expanded(
                child: ListTile(
                  title: Text('시작 날짜'),
                  subtitle: Text(
                    handler.firstDate.value.isEmpty
                      ? '선택된 날짜 없음'
                      : handler.firstDate.value,
                  ),
                  trailing: Icon(Icons.calendar_today,color: Colors.blue),
                  onTap: () async{
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: Locale('ko','KR'),
                      );
                      if(picked != null){
                        handler.firstDate.value = _formatter.format(picked);
                        handler.selectEachStoreFirstToFinal('강남');
                        
                      }
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('종료 날짜'),
                  subtitle: Text(
                    handler.firstDate.value.isEmpty
                      ? '선택된 날짜 없음'
                      : handler.finalDate.value,
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
                      lastDate: DateTime(2100),
                      locale: Locale('ko','KR'),
                      );
                      if(picked != null){
                        handler.finalDate.value = _formatter.format(picked);
                        handler.selectEachStoreFirstToFinal('강남');
                      }
                  },
                ),
              ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('매출'),
                      Text('0원')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('주문 건수'),
                      Text('0건')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('환불'),
                      Text('0월')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('환불 건수'),
                      Text('0건'),
                    ],
                  )

                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.5,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: '기간 별 총 매출액'
                  ),
                  tooltipBehavior: tooltipBehavior,
                  legend: Legend(isVisible: true),
                  series: [
                    ColumnSeries<PurchaseWithProductDate, String>(
                      color: Theme.of(context).colorScheme.primary,
                      name: 'Period Total Prices',
                      dataSource: handler.firstToFinalList,
                      xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate,
                      yValueMapper: (PurchaseWithProductDate prices, _) => prices.totalPrice,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,)
                  ],
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                  primaryYAxis: CategoryAxis(
                    title: AxisTitle(text: '매출 액',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.5,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: '기간 별 누적 총 매출액'
                  ),
                  tooltipBehavior: tooltipBehavior,
                  legend: Legend(isVisible: true),
                  series: [
                    LineSeries<PurchaseWithProductDate, String>(
                      color: Theme.of(context).colorScheme.primary,
                      name: 'Cumulative Total Prices',
                      dataSource: handler.firstToFinalList,
                      xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate,
                      yValueMapper: (PurchaseWithProductDate cumulative, _) => cumulative.cumulativeTotalPrice,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,)
                  ],
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                  primaryYAxis: CategoryAxis(
                    title: AxisTitle(text: '누적 매출 액',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.5,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: '기간 별 누적 총 제품 갯수'
                  ),
                  tooltipBehavior: tooltipBehavior,
                  legend: Legend(isVisible: true),
                  series: [
                    LineSeries<PurchaseWithProductDate, String>(
                      color: Theme.of(context).colorScheme.primary,
                      name: 'Cumulative Total Sales Counts',
                      dataSource: handler.firstToFinalList,
                      xValueMapper: (PurchaseWithProductDate date, _) => date.tranDate,
                      yValueMapper: (PurchaseWithProductDate cumulative, _) => cumulative.cumulativeSalesCount,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,)
                  ],
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: '일자',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                  primaryYAxis: CategoryAxis(
                    title: AxisTitle(text: '누적 제춤 수',textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ),
              )
            ],
          ),
        );
        },
        ),
      ) 
    );
  }
}