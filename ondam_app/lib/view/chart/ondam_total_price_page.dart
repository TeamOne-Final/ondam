import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ThirdPage extends StatelessWidget {
  ThirdPage({super.key});
  final VmHandlerTemp handler = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    handler.retailerTotalPrice();
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text('제품 별 매출 보기',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: backgroundColor,
        centerTitle: false,
      ),
      body:Obx(() {
        if(handler.prices.isEmpty){
          return Center(child: CircularProgressIndicator());
        }
        return Center(
          child: SfCartesianChart(
            title: ChartTitle(
              text: '온담 매장 별 총 매출',
              textStyle: TextStyle(
              fontWeight: FontWeight.bold
              ),
            ),
            tooltipBehavior: tooltipBehavior,
            legend: Legend(isVisible: true),
            series: [
              ColumnSeries<Chart,String>(
                color: mainColor,
                name: "Total Prices",
                dataSource: handler.prices,
                xValueMapper: (Chart stores, _) => stores.companyCode,
                yValueMapper: (Chart prices, _) => prices.totalPrice,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true
                ),
                enableTooltip: true,
                ),
            ],
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: '매장 명',textStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            primaryYAxis: NumericAxis(
              plotOffset: 0,
              title: AxisTitle(text: '매출 액',textStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },)
    );
  }
}