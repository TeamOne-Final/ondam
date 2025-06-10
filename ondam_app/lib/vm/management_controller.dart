import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/model/manager.dart';
import 'package:ondam_app/vm/gps_controller.dart';

class ManagementController extends GpsController{
  var employeeList = <Manager>[].obs;
  var managerId = ''.obs;
  var companyCode = ''.obs;
  var managerPassword = ''.obs;
  var location = '';

  Future<void> fetchEmployee() async {
    try{
    final response = await http.get(Uri.parse('http://$globalIP/taemin/select/employee'));
    final data = json.decode(utf8.decode(response.bodyBytes));
    List results = data['results'];
  List<Manager> returnResult = 
                  results.map((data) {
                    return Manager(
                      managerId: data['managerId'],
                      companyCode : data['companyCode'],
                      managerPassWord: data['managerPassword'],
                      location: data['location']
                    );
                  }).toList();
      employeeList.value = returnResult;
    } catch(e){
      //
  }
  }
}