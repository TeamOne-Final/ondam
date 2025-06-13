// 본사 메인
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompanyMain extends StatelessWidget {
  CompanyMain({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    controller.selectDayTop3Retailer();
    controller.mainTotalPrice();
    return Obx(
      () => Scaffold(
        backgroundColor: Color(0xFFF6F7FB),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: [
              // CompanySideMenu(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                      child: Row(
                        children: [
                          Text('${box.read('companyCode')}', style: TextStyle(fontSize: 40)),
                          Spacer(),
                          Obx(() => SizedBox(width: 520, child: Text("${controller.dateTimeNow.toString().substring(0,4)}년 ${controller.dateTimeNow.toString().substring(5,7)}월 ${controller.dateTimeNow.toString().substring(8,10)}일 ${controller.dateTimeNow.toString().substring(11,19)}", style: TextStyle(fontSize: 40))),),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildContainer(
                          context,
                          '총 매장 수',
                          '${controller.storeCount.value}개',
                        ),
                        _buildContainer(
                          context,
                          '일자 총 매출',
                          '${controller.todaySales.value}원',
                        ),
                        _buildContainer(
                          context,
                          '당월 방문 고객 성비',
                          (controller.maleCount.value + controller.femaleCount.value) == 0?
                          '방문 고객이 없습니다.'
                          :'남 ${((controller.maleCount.value / (controller.maleCount.value + controller.femaleCount.value))*10).toStringAsFixed(0)} : 여 ${(controller.femaleCount.value / ((controller.maleCount.value + controller.femaleCount.value))*10).toStringAsFixed(0)}',
                        ),
                        _buildContainer(
                          context,
                          '이슈(수정 필요)',
                          '${controller.storeCount.value}건',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 10, 20),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / 2.9,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SfCartesianChart(
                              title: ChartTitle(text: '금월 매출'),
                              tooltipBehavior: tooltipBehavior,
                              legend: Legend(isVisible: true),
                              series: [
                                LineSeries<Chart, String>(
                                  name: '금월 매출',
                                  dataSource: controller.mainTotalPriceList,
                                  xValueMapper:
                                      (Chart tranDate, _) => tranDate.tranDate,
                                  yValueMapper:
                                      (Chart totalPrice, _) =>
                                          totalPrice.totalPrice,
                                  dataLabelSettings: DataLabelSettings(
                                    textStyle: TextStyle(fontSize: 8),
                                    isVisible: true,
                                  ),
                                  enableTooltip: true,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                ScatterSeries<Chart, String>(
                    name: '금월 매출',
                    dataSource: controller.mainTotalPriceList,
                    xValueMapper: (Chart tranDate, _) => tranDate.tranDate, 
                    yValueMapper: (Chart totalPrice, _) =>
                                          totalPrice.totalPrice,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true)
                              ],
                              primaryXAxis: CategoryAxis(
                                title: AxisTitle(
                                  text: '일자',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              primaryYAxis: CategoryAxis(
                                title: AxisTitle(
                                  text: '매출 액',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / 2.9,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SfCartesianChart(
                              title: ChartTitle(text: '금일 매출 상위 3개 매장'),
                              tooltipBehavior: tooltipBehavior,
                              legend: Legend(isVisible: true),
                              series: [
                                BarSeries<Chart, String>(
                                  width: 0.3,
                                  color: Theme.of(context).colorScheme.primary,
                                  name: "Admin Store year and select Store",
                                  dataSource:
                                      controller.selectDayTop3RetailerList,
                                  xValueMapper:
                                      (Chart date, index) => date.companyCode,
                                  yValueMapper:
                                      (Chart prices, index) => prices.totalPrice,
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                  ),
                                  enableTooltip: true,
                                ),
                              ],
                              primaryXAxis: CategoryAxis(
                                title: AxisTitle(
                                  text: '매장',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              primaryYAxis: CategoryAxis(
                                title: AxisTitle(
                                  text: '매출 액',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 15, 15, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 1.37,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('매장명')),
                              DataColumn(label: Text('지역')),
                              DataColumn(label: Text('금일 결제 견수')),
                              DataColumn(label: Text('운영상태')),
                            ],
                            rows:
                                controller.storeList1.map((store) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(store['managerId'])),
                                      DataCell(Text("${store['companyCode']}점")),
                                      DataCell(Text(store['location'])),
                                      DataCell(Text("${store['purchase']??0}건")),
                                      DataCell(Text('운영 중')),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  // --- Widgets ---
  _buildContainer(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
      child: Container(
        width: MediaQuery.sizeOf(context).width / 6.2,
        height: MediaQuery.sizeOf(context).height / 9.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
              child: Text(title, style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
              child: Text(
                content,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: content == '방문 고객이 없습니다.'? 20 : 30,),
              ),
            ),
          ],
        ),
      ),
    );
  }
} // class
