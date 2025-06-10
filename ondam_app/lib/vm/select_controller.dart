import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/vm/purchase_controller.dart';

class SelectController extends PurchaseController {
  RxInt selectedIndexfordropdown = 0.obs;
  RxList<Map<String, dynamic>> shoppingList = <Map<String, dynamic>>[].obs;

  RxBool isEndDrawerOpen = false.obs;

  Rx<Map<String, dynamic>?> selectedDrawerItem = Rx<Map<String, dynamic>?>(
    null,
  );

  void selectdropdown(int index) {
    selectedIndexfordropdown.value = index;
    selectedDrawerItem.value = null;
  }

  void selectItemForDrawer(Map<String, dynamic> item) {
    selectedDrawerItem.value = item;
  }

  void clearSelectedDrawerItem() {
    selectedDrawerItem.value = null;
  }

// -- 대리점 메뉴 선택
  Future<dynamic> insertSelect(String companyId, String menuCode) async {
    try{
    final res = await http.get(Uri.parse('$baseUrl/taemin/insert/select?menuCode=$menuCode&companyId=$companyId'));
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    return result;
    } catch(e){
      //
    }
  }

  // 대리점 메뉴 삭제
  Future<String> deleteSelect(String companyId, String menuCode) async {
    final uri = Uri.parse('$baseUrl/taemin/delete/select?menuCode=$menuCode&companyId=$companyId');
    final res = await http.get(uri);
    final result = json.decode(utf8.decode(res.bodyBytes))['result'];
    return result;
  }
}
