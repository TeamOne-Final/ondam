import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FourthPage extends StatelessWidget {
  FourthPage({super.key});
  final VmHandlerTemp handler = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,        
        centerTitle: false,
        title: Text('대리점 별 년/월별 매출',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: backgroundColor,
        actions: [
          Obx(() => Row(
            children: [
            DropdownButton<String>(
              value: handler.selectedYear.value,
              icon: Icon(Icons.keyboard_arrow_down),
              dropdownColor: backgroundColor,
              items: handler.yearList.map<DropdownMenuItem<String>>((String yearString){
                return DropdownMenuItem(
                  value: yearString,
                  child: Text(
                    yearString,
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                  );
              }).toList(),
              onChanged: (String? newValue) {
                if(newValue != null){
                handler.selectedYear.value = newValue;
                handler.retailerMonthPrice();
                }
              },
            ),
            DropdownButton<String>(
              value: handler.selectedMonth.value,
              icon: Icon(Icons.keyboard_arrow_down),
              dropdownColor: backgroundColor,
              items: handler.monthList.map<DropdownMenuItem<String>>((String monthString){
                return DropdownMenuItem(
                  value: monthString,
                  child: Text(
                    monthString,
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                  );
              }).toList(),
              onChanged: (String? newValue) {
                if(newValue != null){
                handler.selectedMonth.value = newValue;
                handler.retailerMonthPrice();
                }
              },
            ),
            ],
          ),)
        ],
      ),
      body: Obx(() {
        if(handler.pricesMonth.isEmpty){
          return Center(child: Text('데이터를 불러오는 중입니다. \n 위의 카테고리를 선택하지 않았다면 위의 년도와 월를 선택해 주세요'));
        }
        return Center(
          child: SfCartesianChart(
            title: ChartTitle(
              text: '대리점 년/월별 매출',
              textStyle: TextStyle(
              fontWeight: FontWeight.bold
              ),
              ),
              tooltipBehavior: tooltipBehavior,
              legend: Legend(isVisible: true),
              series: [
                BarSeries<Chart,String>(
                color: mainColor,
                name: "Store select year and month",
                dataSource: handler.pricesMonth,
                  xValueMapper: (Chart date, index) => date.companyCode,
                  yValueMapper: (Chart prices, index) => prices.totalPrice,
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
        },
      ),
    );
  }
}