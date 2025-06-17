import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/global_ip.dart';
import 'package:ondam_app/view/home.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/widget/custom_text_field.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
        body: Center(
          child: SingleChildScrollView(
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
                          obscureText: true,
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
        ),
      ),
    );
  }

  loginCheck(String id, String pw) async {
    try {
      List<Map<String, dynamic>> loginResultList = await getJSONData(id, pw);

      // 받아온 리스트가 비어있는지 확인하여 로그인 성공/실패를 판단합니다.
      if (loginResultList.isNotEmpty) {
        // 리스트가 비어있지 않다면, 로그인 성공입니다.
        // FastAPI 코드는 성공 시 [{'count': 1, 'companyCode': '...'}] 형태를 반환하므로,
        // 첫 번째 요소에서 count와 companyCode를 추출합니다.
        int? count =
            loginResultList[0]['count'] as int?; // count 값을 안전하게 가져옵니다.
        String? companyCode =
            loginResultList[0]['companyCode']
                as String?; // companyCode 값을 안전하게 가져옵니다.
        if (count == 1 && companyCode != null) {
          // count가 1이고 companyCode가 null이 아닐 때 성공
          // 로그인 성공!
          print('로그인 성공! 회사 코드: $companyCode');
          if (companyCode == '본사') {
            Get.snackbar('로그인 성공', '환영합니다', backgroundColor: Colors.green,colorText: Colors.black);
            saveStorage(companyCode); // companyCode 저장 함수 호출
            Get.to(() => Home()); // 본사 화면으로 이동
          } else {
            Get.to(() => StoreMain()); // 대리점 화면으로 이동
            Get.snackbar('로그인 성공', '환영합니다', backgroundColor: Colors.green,colorText: Colors.black);
            saveStorage(companyCode);
          }
        } else {
          Get.snackbar('오류', '로그인 처리 중 문제가 발생했습니다.', backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('오류', 'Id 혹은 password가 일치하지 않습니다.',backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('오류', '로그인 중 문제가 발생했습니다: ${e.toString()}',backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<List<Map<String, dynamic>>> getJSONData(String id, String pw) async {
    final url = Uri.parse("http://$globalIP/inhwan/selectUser");

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'managerId': id,
          'managerPassword': pw,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        // 'results' 키가 존재하고 리스트 형태인지 확인
        if (jsonResponse.containsKey('results') &&
            jsonResponse['results'] is List) {
          // List<dynamic>를 List<Map<String, dynamic>>으로 안전하게 변환하여 반환
          return jsonResponse['results'].cast<Map<String, dynamic>>();
        } else {
          // 'results' 키가 없거나 리스트가 아닐 경우
          throw Exception('Invalid server response format'); // 예외 발생
        }
      } else {
        if (response.statusCode == 401) {
          throw Exception('Invalid credentials'); // 아이디 또는 비밀번호 오류
        } else {
          throw Exception(
            'Login failed with status: ${response.statusCode}',
          ); // 기타 서버 오류
        }
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생 시
      throw Exception('Error during login request: ${e.toString()}');
    }
  }

  saveStorage(String companyCode) {
    box.write('mid', idController.text);
    box.write('companyCode', companyCode);
  }
}
