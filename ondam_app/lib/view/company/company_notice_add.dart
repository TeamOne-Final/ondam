// 공지사항 추가
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CompanyNoticeAdd extends StatelessWidget {
  CompanyNoticeAdd({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          // CompanySideMenu(),
        ]
      )
    );
  }
}