import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/vm/manager_controller.dart';
import 'package:http/http.dart' as http;

class ProductController extends ManagerController{
  RxList itemList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItemList('%');
  }

  void fetchItemList(String category) async{
    final response0 = await http.get(Uri.parse('http://$globalIP/hakhyun/select/item_list/$category'));
    final data0 = jsonDecode(response0.body);
    itemList.value = List<Map<String, dynamic>>.from(data0['results']);
  }

  void insertItem(code, name, description, price, imageFile, firstDisp) async{
    var request = http.MultipartRequest(
      "POST", 
      Uri.parse("http://$globalIP/hakhyun/insert/item")
    );
    request.fields['menuCode'] = code;
    request.fields['menuName'] = name;
    request.fields['menuPrice'] = price;
    request.fields['description'] = description;
    request.fields['date'] = DateTime.now().toString();
    request.files.add(await http.MultipartFile.fromPath('file', imageFile!));
    var res = await request.send();
    if(res.statusCode == 200){
      fetchItemList('');
      showDialog('추가가');
    }else{
      errorSnackBar();
    }
  }

  void updateItem(code, name, description, price, [imageFile, firstDisp]) async{
    final uri = firstDisp == 0
      ? Uri.parse("http://$globalIP/hakhyun/update/item")
      : Uri.parse("http://$globalIP/hakhyun/update/item_with_image");
    var request = http.MultipartRequest(
      "POST", 
      uri
    );
    request.fields['menuCode'] = code;
    request.fields['menuName'] = name;
    request.fields['menuPrice'] = price;
    request.fields['description'] = description;
    request.fields['date'] = DateTime.now().toString();
    if (firstDisp != 0 && imageFile != null){
      request.files.add(await http.MultipartFile.fromPath('file', imageFile!));
    }
    var res = await request.send();
    if(res.statusCode == 200){
      showDialog('수정이');
    }else{
      errorSnackBar();
    }
  }

    void deleteItem(String code)async{
    var response = await http.delete(Uri.parse("http://$globalIP/hakhyun/delete/item/$code"));
    var result = json.decode(utf8.decode(response.bodyBytes))['result'];
    if(result != "OK"){
      errorSnackBar();
    }else{
      fetchItemList('');
      showDialog('삭제가');
    }
  }

    void errorSnackBar(){
    Get.snackbar(
      "경고", 
      "실행 중 문제가 발생했습니다",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red,
      );
  }

  showDialog(String action){
    Get.defaultDialog(
      title: '실행 결과',
      middleText: '$action 완료되었습니다.',
      titleStyle: TextStyle(fontSize: 24),
      middleTextStyle: TextStyle(fontSize: 20),
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: Text('나가기',style: TextStyle(fontSize: 18),),
        ),
      ]
    );
  }
  

}