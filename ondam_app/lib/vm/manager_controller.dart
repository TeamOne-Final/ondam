import 'dart:convert';

import 'package:get/get.dart';
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/vm/management_controller.dart';
import 'package:http/http.dart' as http;

class ManagerController extends ManagementController{
  RxInt storeCount = 0.obs;
  RxInt todaySales = 0.obs;
  RxInt todayOrderCount = 0.obs;
  RxList storeList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStoreCount();
  }

  void fetchStoreCount() async {
    final response0 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/store_count'));
    final response1 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/today_sales'));
    final response2 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/today_order_count'));
    final response3 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/store_list'));
    final data0 = jsonDecode(response0.body);
    final data1 = jsonDecode(response1.body);
    final data2 = jsonDecode(response2.body);
    final data3 = jsonDecode(response3.body);
    storeCount.value = (data0['result']??0)as int;
    todaySales.value = (data1['result']??0)as int;
    todayOrderCount.value = (data2['result']??0)as int;
    storeList.value = (data3['results']??[])as List;
  }
}