import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/usertable_controller.dart';

class ChartController extends UsertableController{
  final String baseUrl = 'http://127.0.0.1:8000';
  final RxList<Chart> prices = <Chart>[].obs;   // retailerTotalPrice
  final RxList<Chart> pricesMonth = <Chart>[].obs; // retailerMonthPrice
  final RxList<Chart> monthMenu = <Chart>[].obs; // menuMonthTotalPrice
  final RxList<Chart> selectRetailerMonthList = <Chart>[].obs; // selectRetailerMonth
  final RxList<Chart> selectRetailerDayList = <Chart>[].obs; // selectRetailerDay
  final RxList<String> yearList = ['2024년' ,'2025년','2026년'].obs;
  final RxList<String> monthList = ['01월', '02월', '03월', '04월', '05월', '06월', '07월', '08월', '09월', '10월', '11월', '12월'].obs;
  final RxList<String> storeList = ['강남점','서초점','역삼점'].obs;


  var selectedYear = ''.obs; // 년도 dropdownbutton
  var selectedMonth = ''.obs; // 월 dropdownbutton
  var selectedStore = ''.obs; // 점포 dropdownbutton

@override
  void onInit() {
    super.onInit();
    selectedYear.value = yearList[0];
    selectedMonth.value = monthList[0];
    selectedStore.value = storeList[0];
  }

  // ondam_total_price_page
  Future<void> retailerTotalPrice() async{
    try{
      prices.clear();
      
      final res = await http.get(Uri.parse("$baseUrl/taemin/select/companyCode/totalPrice"));
      final data = json.decode(utf8.decode(res.bodyBytes));
      final List results = data['results'];
      final List<Chart> returnResult =
      results.map((data) {
        return Chart(
          companyCode: data['companyCode'],
          quantity: data['quantity'],
          totalPrice: data['totalprice']
          );
      }).toList();

      prices.value = returnResult;
    }catch(e){
      //
    }
  }

  String getYearWithoutKo(){
    return selectedYear.substring(0,4);
  }
  String getMonthWithoutKo(){
    return selectedMonth.substring(0,2);
  }
  String getStoreOnlyDistrict(){
    return selectedStore.replaceAll('점','');
  }


  // ondam_store_price_page
  Future<void> retailerMonthPrice() async{
    final year = getYearWithoutKo();
    final month = getMonthWithoutKo();
    try{
      pricesMonth.clear();
      final res = await http.get(Uri.parse("$baseUrl/taemin/select/companyCode/totalPrice/month?year=$year&month=$month"));
      final data = json.decode(utf8.decode(res.bodyBytes));
      final List results = data['results'];
      final List<Chart> returnResult =
      results.map((data) {
        return Chart(
          companyCode: data['companyCode'],
          quantity: data['quantity'],
          totalPrice: data['totalprice']
          );
      }).toList();

      pricesMonth.value = returnResult;
    }catch(e){
      //
    }
  }

// ondam_menu_total_month
    Future<void> menuMonthTotalPrice() async{
      final year = getYearWithoutKo();
      final month = getMonthWithoutKo();
    try{
      monthMenu.clear();
      final res = await http.get(Uri.parse("$baseUrl/taemin/select/menuCode/?year=$year&month=$month"));
      final data = json.decode(utf8.decode(res.bodyBytes));
      final List results = data['results'];
      final List<Chart> returnResult =
      results.map((data) {
        return Chart(
          menuName: data['menuName'],
          totalPrice: data['totalPrice'],
          );
      }).toList();
      monthMenu.value = returnResult;

    }catch(e){
      //
    }
  }


// 본사 년/월별 매출 admin_select_store
  Future<void> selectRetailerMonth() async {
    final year = getYearWithoutKo();
    final comCode = getStoreOnlyDistrict();
    try{
    selectRetailerMonthList.clear();
    var url =  Uri.parse('$baseUrl/taemin/select/select_year/month/total/date=?year=$year&comCode=$comCode');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<Chart> returnResult = 
                  results.map((data) {
                    return Chart(
                      tranDate: data['tran_date'],
                      totalPrice: data['total_price']
                    );
                  }).toList();
      selectRetailerMonthList.value = returnResult;
    } catch(e){
      //
    }
  }

  // admin_day_price

  Future<void> selectRetailerDay() async {
    final year = getYearWithoutKo();
    final month = getMonthWithoutKo();
    final comCode = getStoreOnlyDistrict();
    try{
    selectRetailerDayList.clear();
    var url =  Uri.parse('$baseUrl/taemin/select/select_month_day/total/date=?year=$year&month=$month&comCode=$comCode');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<Chart> returnResult = 
                  results.map((data) {
                    return Chart(
                      tranDate: data['tran_date'],
                      totalPrice: data['total_price']
                      );
                  }).toList();
      selectRetailerDayList.value = returnResult;
    } catch(e){
      //
    } 
  }
}