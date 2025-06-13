import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/purchase.dart';
import 'package:ondam_app/model/purchase_poduct.dart';
import 'package:ondam_app/model/purchase_with_product.dart';
import 'package:ondam_app/model/chart.dart';
import 'package:ondam_app/vm/product_controller.dart';
import 'package:intl/intl.dart';


class PurchaseController extends ProductController{
  final String baseUrl = 'http://127.0.0.1:8000';
  RxList<PurchasePoduct> purchase = <PurchasePoduct>[].obs;
  var purchases = <Purchase>[].obs;
  var selectedPurchase = Rxn<Purchase>(); // nullable

  final RxList<PurchaseWithProductDate> curToInternalList = <PurchaseWithProductDate>[].obs;
  final RxList<PurchaseWithProductDate> firstToFinalList = <PurchaseWithProductDate>[].obs;
  final RxList<PurchaseWithProductDate> selectOne = <PurchaseWithProductDate>[].obs;
  var productAnalysisForTotalList = <Chart>[].obs;
  var productAnalysisForChartList = <Chart>[].obs;
  var purchaseSituationDataList = <Chart>[].obs;
  var purchaseSituationChartNowList = <Chart>[].obs;
  var purchaseSituationChartPreList = <Chart>[].obs;
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
    productAnalysisChart('강남');
    productAnalysisTotal('강남');

    // 초기 조회
    selectEachStoreFirstToFinal('강남');
    selectTotalSalesCountsOne('강남');
    purchaseSituationData('강남');
    purchaseSituationChart('강남');
    loadPurchase();
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

  // purchase 데이터 load
  Future<void>loadPurchase()async{
    final res = await http.get(Uri.parse("$baseUrl/giho/select/purchase"));
    final data = json.decode(utf8.decode(res.bodyBytes));
    final List results = data["results"];

    final List<PurchasePoduct>returnResult =
      results.map((data) {
        return PurchasePoduct(
          cartNum: data["cartNum"], 
          menuName: data["menuName"], 
          tranDate: data["tranDate"], 
          userTableCompanyCode: data["userTable_CompanyCode"], 
          cartNumTotalPrice: data["cartNum_total_price"]
        );
      },).toList();

    purchase.value = returnResult;
  }


 // 현재 일자에서 30일 동안의 매출
  Future<void> selectEachStoreCurToInternal(String storeCode) async{
    try{
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
    }catch(e){
      //
    }
  }
  // pos상품 분석 페이지 total
  Future<void> productAnalysisTotal(String storecode) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/product_anal/total?firstDate=$firstDate&finalDate=$finalDate&companyCode=$storecode');
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
    var url =  Uri.parse('$baseUrl/sangbeom/select/eachstore/firstDatetofinalDate?storeCode=강남&firstDate=${firstDate.value}&finalDate=${finalDate.value}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJSON['results'];
    List<PurchaseWithProductDate> returnResult = 
                  results.map((data) {
                    return PurchaseWithProductDate(
                      totalPrice: data['totalPrice'] ?? 0,
                      tranDate: data['tranDate'] ?? 0,
                      cumulativeSalesCount: data['cumulativeSalesCount'] ?? 0,
                      cumulativeTotalPrice: data['cumulativeTotalPrice'] ?? 0,
                    );
                  }).toList();
      firstToFinalList.value = returnResult;
    }catch(e){
      //
    }
  }
  // pos상품 분석 페이지 DataTable & PieChart select
  Future<void> productAnalysisChart(String storecode) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/product_anal/chart?firstDate=$firstDate&finalDate=$finalDate&companyCode=$storecode');
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
  // 현황의 값들을 불러오는 것
    Future<void> selectTotalSalesCountsOne(String storeCode) async{
    try{
    var url =  Uri.parse('$baseUrl/sangbeom/select/sales/counts?storeCode=$storeCode&firstDate=${firstDate.value}&finalDate=${finalDate.value}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJSON['results'];
    List<PurchaseWithProductDate> returnResult = 
                  results.map((data) {
                    return PurchaseWithProductDate(
                      totalPrice: data['totalPrices'] ?? 0,
                      countCartNum: data['countCartNum'] ?? 0,
                      refundCount: data['refundCount'] ?? 0,
                      refundPrice: data['refundPrice'] ?? 0
                    );
                  }).toList();
      selectOne.value = returnResult;
      // selectOne[0]['totalPrices'];
    }catch(e){
      //
    }
  }
  // 매출 현황에 필요한 데이터 불러오는 용도
  Future<void> purchaseSituationData(String storeCode) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/purchase/data?storeCode=$storeCode&firstDate=$firstDate&finalDate=$finalDate');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
    List<Chart> returnResult = 
                  results.map((data) {
                    return Chart(
                      totalPrice: data['total_price'] ?? 0,
                      quantity: data['purchase_count'] ?? 0,
                      femaleNum: data['refund_count'] ?? 0,
                      maleNum: data['refund_price'] ?? 0
                    );
                  }).toList();
    purchaseSituationDataList.value = returnResult;
    // print(response.body); // 원본 응답
    // print(dataConvertedJDON); // 디코딩 결과
    // print(results);
    } catch(e){
      //
    } 
  }
  // --- 매출 현황 아래 차트 그리는 용도
  Future<void> purchaseSituationChart(String storeCode) async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/purchase/chart?storeCode=$storeCode&firstDate=$firstDate&finalDate=$finalDate');
    var response = await http.get(url);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
    List results = dataConvertedJDON['results'];
    List nowdata = results[0];
    List predata = results[1];
    List<Chart> returnNowResult = 
                  nowdata.map((data) {
                    return Chart(
                      totalPrice: data['now_total_price'] ?? 0,
                      tranDate: data['nowdate'] ?? ''
                    );
                  }).toList();
    List<Chart> returnPreResult = 
                  predata.map((data) {
                    return Chart(
                      totalPrice: data['pre_total_price'] ?? 0,
                      tranDate: data['predate'] ?? ''
                    );
                  }).toList();
    purchaseSituationChartPreList.value = returnPreResult;
    purchaseSituationChartNowList.value = returnNowResult;
    } catch(e){
      //
    } 
  }
}