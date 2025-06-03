import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/widget/custom_text_field.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final idController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
      body: Center(
        child: Column(
          children: [
            Image.asset('images/ondamlogo.png'),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),
              width: MediaQuery.sizeOf(context).width/2,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    child: CustomTextField(label: '아이디를 입력해 주세요', controller: idController)
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    child: CustomTextField(label: '비밀번호를 입력해 주세요', controller: passController)
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(idController.text.isEmpty || passController.text.isEmpty){
                        Get.snackbar('error', 'please write id or pw', backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 1));
                      }
                    }, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black,minimumSize: Size(MediaQuery.sizeOf(context).width/2.5, 40)),
                    child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}