import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/purchase_with_product.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/product_controller.dart';
import 'package:intl/intl.dart';


class PurchaseController extends ProductController{
  final String baseUrl = 'http://127.0.0.1:8000';

  final RxList<PurchaseWithProductDate> curToInternalList = <PurchaseWithProductDate>[].obs;
  final RxList<PurchaseWithProductDate> firstToFinalList = <PurchaseWithProductDate>[].obs;
  var productAnalysisForTotalList = <Chart>[].obs;
  var productAnalysisForChartList = <Chart>[].obs;
  var firstDate = ''.obs;
  var finalDate = ''.obs;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    super.onInit();
    // 초기 날짜: 오늘과 29일 전 설정
    final today = DateTime.now();
    finalDate.value = _formatter.format(today);
    firstDate.value = _formatter.format(today.subtract(Duration(days: 29)));
    productAnalysisChart('2025-05-05');
    productAnalysisTotal('2025-05-05');

    // 초기 조회
    selectEachStoreFirstToFinal('강남');
  }

  // -- cartNum 최댓값
  getMaxCartNum() async {
    final int maxCartNum;
    try{
      final res = await http.get(Uri.parse("$baseUrl/taemin/select/max_cartNum"));
      final data = json.decode(utf8.decode(res.bodyBytes));
      final int result = data['results'][0];
      maxCartNum = result;
      return maxCartNum;
    }catch(e){
      //
    }
  }

  // -- purchase 데이터 insert
  Future<dynamic> insertPurchase(int tableNum, String companyCode, String menuCode, int cartNum, int femaleNum, int maleNum, int quantity) async {
    try{
    final res = await http.get(Uri.parse('$baseUrl/taemin/insert/purchase?cartNum=$cartNum&tableNum=$tableNum&companyCode=$companyCode&menuCode=$menuCode&femaleNum=$femaleNum&maleNum=$maleNum&quantity=$quantity'));
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    return result;
    } catch(e){
      //
    }
  }

  // purchase 데이터 update
  Future<String> updatePurchase(
    int quantity,
    int cartNum,
    String menuCode,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/taemin/update/purchase?quantity=$quantity&cartNum=$cartNum&menuCode=$menuCode',
    );
    final res = await http.get(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    return result;
  }

  // purchase 데이터 delete
  Future<String> deletePurchase(int cartNum, String menuCode) async {
    final uri = Uri.parse('$baseUrl/taemin/delete/purchase?cartNum=$cartNum&menuCode=$menuCode');
    final res = await http.get(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    return result;
  }


 // 현재 일자에서 30일 동안의 매출
  Future<void> selectEachStoreCurToInternal(String storeCode) async{
    try{
    curToInternalList.clear();
    var url =  Uri.parse('$baseUrl/sangbeom/select/eachstore/curTointernal29?storeCode=강남');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJSON['results'];
    List<PurchaseWithProductDate> returnResult = 
                  results.map((data) {
                    return PurchaseWithProductDate(
                      totalPrice: data['totalPrice'],
                      tranDate: data['tranDate']
                    );
                  }).toList();
      curToInternalList.value = returnResult;

  // pos상품 분석 페이지 total
  Future<void> productAnalysisTotal(String date) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/product_anal/total?tranDate=$date');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
    List<Chart> returnResult = 
                  results.map((data) {
                    return Chart(
                      quantity: data['total_quantity'],
                      totalPrice: data['total_price'],
                    );
                  }).toList();
    productAnalysisForTotalList.value = returnResult;

    } catch(e){
      //
    } 
  }


    // 선택한 날짜부터 마지막 날짜까지 기간을 직접 지정(사이 일자 별 매출)
  Future<void> selectEachStoreFirstToFinal(String storeCode) async{
    try{
    firstToFinalList.clear();
    var url =  Uri.parse('$baseUrl/sangbeom/select/eachstore/firstDatetofinalDate?storeCode=강남&firstDate=${firstDate.value}&finalDate=${finalDate.value}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJSON['results'];
    List<PurchaseWithProductDate> returnResult = 
                  results.map((data) {
                    return PurchaseWithProductDate(
                      totalPrice: data['totalPrice'],
                      tranDate: data['tranDate'],
                      cumulativeSalesCount: data['cumulativeSalesCount'],
                      cumulativeTotalPrice: data['cumulativeTotalPrice']
                    );
                  }).toList();
      firstToFinalList.value = returnResult;
  // pos상품 분석 페이지 DataTable & PieChart select
  Future<void> productAnalysisChart(String date) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/product_anal/chart?tranDate=$date');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
    List<Chart> returnResult = 
                  results.map((data) {
                    return Chart(
                      menuName: data['menuName'],
                      quantity: data['total_quantity'],
                      totalPrice: data['total_price'],
                    );
                  }).toList();
    productAnalysisForChartList.value = returnResult;

    } catch(e){
      //
    } 
  }

}