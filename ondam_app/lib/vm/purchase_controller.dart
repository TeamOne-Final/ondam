import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ondam_app/model/purchase.dart';
import 'package:ondam_app/vm/product_controller.dart';

class PurchaseController extends ProductController{
  final String baseUrl = 'http://127.0.0.1:8000';


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

}