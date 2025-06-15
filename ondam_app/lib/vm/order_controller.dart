import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/order.dart';
import 'package:ondam_app/vm/tab_model.dart';

class OrderController extends TabModel {

  var selectorderList = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectorder();
  }

//--- 주문 데이터 
Future<void> selectorder() async {
    try{
    var url =  Uri.parse('$baseUrl/taemin/select/order');
    var response = await http.get(url);
      // print(response);
    var dataConvertedJDON = json.decode(utf8.decode(response.bodyBytes));
      // print(dataConvertedJDON);
    List results = dataConvertedJDON['results'];
    List<Order> returnResult = 
                  results.map((data) {
                    return Order(
                      contractNum: data['contractNum'],
                      factoryName: data['factoryName'],
                      companyCode: data['companyCode'],
                      ingredientName: data['ingredientName'],
                      price: data['deliveryPrice'],
                      quantity: data['deliveryQuantity'],
                      contractDate: data['contractDate'],
                      deliveryDate: data['deliveryDate'],
                      factoryCode: null, // JSON에 없음 → null 처리
                      ingredientCode: null 
                    );
                  }).toList();
      print(returnResult);
      print(returnResult.length);
      selectorderList.assignAll(returnResult);
      selectorderList.refresh();
      print('ss1122 $selectorderList');
    } catch(e){
      //
    } 
  }

  // 주문 데이터 도착일자 추가
  Future<dynamic> insertDelivery(String factoryCoed, String ingredientCode, String managerId, int quantity) async {
    final uri = Uri.parse('$baseUrl/taemin/insert/delivery?factorycode=$factoryCoed&ingredientcode=$ingredientCode&managerid=$managerId&quantity=$quantity',);
    final res = await http.post(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    print(res);
    print(result);
    return result;
  }
  // 주문 데이터 도착일자 추가
  Future<String> updateDelivery(int contractNum) async {
    final uri = Uri.parse('$baseUrl/taemin/update/delivery?contractNum=$contractNum',);
    final res = await http.post(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    print(res);
    print(result);
    return result;
  }

  Future<String> deleteDelivery(int contractNum) async {
    final uri = Uri.parse('$baseUrl/taemin/delete/delivery?contractNum=$contractNum',);
    final res = await http.post(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    print(res);
    print(result);
    return result;
  }

}