import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  final VmHandlerTemp handler = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF6F7FB),
        centerTitle: false,
        title: Text('본사 일별 매출',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          Obx(() => Row(
            children: [
            DropdownButton<String>(
              dropdownColor: Color(0xFFF6F7FB),
              value: handler.selectedYear.value,
              icon: Icon(Icons.keyboard_arrow_down),
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
                handler.selectRetailerDay();
                }
              },
            ),
            DropdownButton<String>(
              dropdownColor: Color(0xFFF6F7FB),
              value: handler.selectedMonth.value,
              icon: Icon(Icons.keyboard_arrow_down),
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
                handler.selectRetailerDay();
                }
              },
            ),
            DropdownButton<String>(
              dropdownColor: backgroundColor,
              value: handler.selectedStore.value,
              icon: Icon(Icons.keyboard_arrow_down),
              items: handler.storeList.map<DropdownMenuItem<String>>((String storeString){
                return DropdownMenuItem(
                  value: storeString,
                  child: Text(
                    storeString,
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                  );
              }).toList(),
              onChanged: (String? newValue) {
                if(newValue != null){
                handler.selectedStore.value = newValue;
                handler.selectRetailerDay();
                }
              },
            ),
            ],
          ),)
        ],
      ),
      body: Obx(() {
        if(handler.selectRetailerDayList.isEmpty){
          return Center(child: Text('데이터를 불러오는 중입니다. \n 위의 카테고리를 선택하지 않았다면 위의 년도, 월, 점포를 선택해 주세요'));
        }
        return Center(
          child: SfCartesianChart(
            title: ChartTitle(
              text: '본사 일별 매출 확인',
              textStyle: TextStyle(
              fontWeight: FontWeight.bold
              ),
              ),
              tooltipBehavior: tooltipBehavior,
              legend: Legend(isVisible: true),
              series: [
                BarSeries<Chart,String>(
                color: mainColor,
                name: "Admin Store year,month and select Store",
                dataSource: handler.selectRetailerDayList,
                  xValueMapper: (Chart date, index) => date.tranDate,
                  yValueMapper: (Chart prices, index) => prices.totalPrice,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true
                  ),
                  enableTooltip: true,
                  
                  ),
              ],
              primaryXAxis: CategoryAxis(
                title: AxisTitle(text: '날짜(일)',textStyle: TextStyle(fontWeight: FontWeight.bold)),
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