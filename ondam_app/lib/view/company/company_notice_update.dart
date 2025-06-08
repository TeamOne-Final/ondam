// 공지사항 업데이트
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/widget/company_side_menu.dart';

class CompanyNoticeUpdate extends StatelessWidget {
  CompanyNoticeUpdate({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          CompanySideMenu(),
        ]
      )
    );
  }
}