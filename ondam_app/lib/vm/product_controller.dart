import 'dart:convert';

import 'package:get/get.dart';
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/vm/manager_controller.dart';
import 'package:http/http.dart' as http;

class ProductController extends ManagerController{
  RxList itemList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItemList();
  }

  void fetchItemList() async{
    final response0 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/item_list'));
    final data0 = jsonDecode(response0.body);
    itemList.value = List<Map<String, dynamic>>.from(data0['results']);
  }
}