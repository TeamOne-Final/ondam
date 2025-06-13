import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/purchase.dart';
import 'package:ondam_app/model/purchase_poduct.dart';
import 'package:ondam_app/vm/product_controller.dart';

class PurchaseController extends ProductController{
  final String baseUrl = 'http://127.0.0.1:8000';
  RxList<PurchasePoduct> purchase = <PurchasePoduct>[].obs;
  var purchases = <Purchase>[].obs;
  var selectedPurchase = Rxn<Purchase>(); // nullable


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


@override
void onInit() {
  super.onInit();
  loadPurchase(); 
}
}