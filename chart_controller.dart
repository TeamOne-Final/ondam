import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/model/chart_model.dart';
import 'package:test_app/model/select_chart_model.dart';

class ChartController extends GetxController{
  String baseuUrl = 'http://127.0.0.1:8000';
  var chartList = <ChartModel>[].obs;
  var accumulateList = <SelectChartModel>[].obs;
  var selectDateList = <SelectChartModel>[].obs;
  var accumulateMenuList = <SelectChartModel>[].obs;
  var selectDateTotalList = <SelectChartModel>[].obs;
  var isLoading = F.obs;  
  var errorMessage = ''.obs;

  // @override
  // void onInit(){
  //   super.onInit();
  //   // getAccumulateTotal();
  //   // fetchSelectAll();
  // }

  // Future<void> fetchSelectAll() async{
  //   try{
  //   isLoading.value = T;
  //   errorMessage.value = '';
  //   var url =  Uri.parse('$baseuUrl/select/all');
  //   var response = await http.get(url);
  //   var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
  //   List results = dataConvertedJDON['results'];
  // List<ChartModel> returnResult = 
  //                 results.map((e) {
  //                   return ChartModel(tableNum: e['userTable_TableNum'], companyCode: e['userTable_CompanyCode'], menuCode: e['product_MenuCode'], cartNum: e['cartNum'], tranDate: e['tranDate'], femaleNum: e['femaleNum'], maleNum: e['maleNum'], quantity: e['quantity'], price: e['menuPrice']);
  //                 }).toList();
  //     chartList.value = returnResult;
  //   } catch(e){
  //     errorMessage.value = '데이터를 불러오는데 실패했습니다. \n${e.toString()}';
  //   } finally{
  //     isLoading.value = F;
  //   }
  // }
 // --- 누적 매출
  Future<void> getAccumulateTotal() async {
    try{
    isLoading.value = T;
    errorMessage.value = '';
    var url =  Uri.parse('$baseuUrl/select/totalPrice');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<SelectChartModel> returnResult = 
                  results.map((e) {
                    return SelectChartModel(companyCode: e['userTable_CompanyCode'],quantity: e['total_quantity'], price: e['total_price']);
                  }).toList();
      accumulateList.value = returnResult;
    } catch(e){
      errorMessage.value = '데이터를 불러오는데 실패했습니다. \n${e.toString()}';
    } finally{
      isLoading.value = F;
    }
  }
// 선택한 일별 월별 매출 합
  Future<void> getSelectStoreDateTotal(String year, String month, String day) async {
    try{
    isLoading.value = T;
    errorMessage.value = '';
    var url =  Uri.parse('$baseuUrl/select/select_store_date_total/date=$year-$month-$day');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<SelectChartModel> returnResult = 
                  results.map((e) {
                    return SelectChartModel(companyCode: e['userTable_CompanyCode'], price: e['total_price']);
                  }).toList();
      selectDateList.value = returnResult;
    } catch(e){
      errorMessage.value = '데이터를 불러오는데 실패했습니다. \n${e.toString()}';
    } finally{
      isLoading.value = F;
    }
  }
// 매뉴 매출 누적 합
  Future<void> getAccumulateMenuTotal() async {
    try{
    isLoading.value = T;
    errorMessage.value = '';
    var url =  Uri.parse('$baseuUrl/select/menu_totalPrice');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<SelectChartModel> returnResult = 
                  results.map((e) {
                    return SelectChartModel(menuName: e['menuName'], quantity: e['total_quantity'], price: e['total_price']);
                  }).toList();
      accumulateMenuList.value = returnResult;
    } catch(e){
      errorMessage.value = '데이터를 불러오는데 실패했습니다. \n${e.toString()}';
    } finally{
      isLoading.value = F;
    }
  }

// 날짜별 매출
  Future<void> getSelectDateTotal(String year, String month, String day) async {
    try{
    isLoading.value = T;
    errorMessage.value = '';
    var url =  Uri.parse('$baseuUrl/select/select_date_total/date=$year-$month-$day');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
  List<SelectChartModel> returnResult = 
                  results.map((e) {
                    return SelectChartModel(price: e['total_price']);
                  }).toList();
      selectDateTotalList.value = returnResult;
    } catch(e){
      errorMessage.value = '데이터를 불러오는데 실패했습니다. \n${e.toString()}';
    } finally{
      isLoading.value = F;
    }
  }


}