import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/global_ip.dart';

class GenderRatioController extends GetxController{
  RxInt maleCount = 0.obs;
  RxInt femaleCount = 0.obs;

  // void genderRatio (){
  //   int genderCount = maleCount.value + femaleCount.value;
  //   maleRatio.value = genderCount == 0 ? 0 : maleCount.value / genderCount;
  //   femaleRatio.value = genderCount == 0 ? 0 : femaleCount.value / genderCount;
  // }

    @override
  void onInit() {
    super.onInit();
    fetchGenderCount();
  }

  void fetchGenderCount() async {
    final response0 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/gender_count'));
    final data0 = jsonDecode(response0.body);
    maleCount.value = (data0["male"]??0)as int;
    femaleCount.value = (data0["female"]??0)as int;
  }
}