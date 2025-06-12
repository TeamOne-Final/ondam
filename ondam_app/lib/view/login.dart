import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/view/home.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/widget/custom_text_field.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  Login({super.key});
  final idController = TextEditingController();
  final passController = TextEditingController();
  final box = GetStorage();
  List data = [];
  int count = 0;
  String companyCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
      body: Center(
        child: Column(
          children: [
            Image.asset('images/ondamlogo.png'),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              width: MediaQuery.sizeOf(context).width / 2,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    child: CustomTextField(
                      label: '아이디를 입력해 주세요',
                      controller: idController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    child: CustomTextField(
                      label: '비밀번호를 입력해 주세요',
                      controller: passController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (idController.text.isEmpty ||
                          passController.text.isEmpty) {
                        Get.snackbar(
                          'error',
                          'please write id or pw',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: Duration(seconds: 1),
                        );
                      } else {
                        loginCheck(idController.text, passController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(
                        MediaQuery.sizeOf(context).width / 2.5,
                        40,
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginCheck(String id, String pw) async {
    await getJSONData(id, pw);
    count = data[0]['count'];
    if (count == 1) {
      companyCode = data[0]['companyCode'];
      Get.snackbar('로그인 성공', '환영합니다');
      if (companyCode == '본사') {
        saveStorage(companyCode);
        Get.to(() => Home());
      } else {
        saveStorage(companyCode);
        Get.to(() => StoreMain());
      }
    } else {
      Get.snackbar('오류', 'Id 혹은 password가 일치하지 않습니다.');
    }
  }

  getJSONData(String id, String pw) async {
    var response = await http.get(
      Uri.parse(
        "http://$globalIP/inhwan/selectUser?managerId=$id&managerPassword=$pw",
      ),
    );
    data.clear();
    data.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
  }

  saveStorage(String companyCode) {
    box.write('mid', idController.text);
    box.write('companyCode', companyCode);
  }
}
