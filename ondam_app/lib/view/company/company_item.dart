// 본사 메뉴 관리
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/widget/company_side_menu.dart';

class CompanyItem extends StatelessWidget {
  CompanyItem({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
    Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          CompanySideMenu(),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                    child: Text('메뉴관리', style: TextStyle(fontSize: 40),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //
                    }, 
                    child: Text('추가'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  itemCount: controller.itemList.length,
                  itemBuilder: (context, index) {
                    final item = controller.itemList[index];
                    return Center(
                      child: Container(
                        width: 600,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                      color: Colors.white, // 배경 색
                      borderRadius: BorderRadius.circular(16), // 모서리 둥글게
                      boxShadow: [ // 그림자 효과
                        BoxShadow(
                          color: Colors.grey.withAlpha((255 * 0.2).round()),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300), // 연한 테두리
                          ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item['menuImage'] != null && item['menuImage'].toString().isNotEmpty
                                  ? Image.memory(
                                      base64Decode(item['menuImage']),
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image_not_supported, size: 80),
                            ),
                            SizedBox(width: 20),
                            // 이름과 가격
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['menuName'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text("₩${item['menuPrice']}", style: TextStyle(fontSize: 22, color: Colors.black54)),
                                ],
                              ),
                            ),
                            // 버튼들
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // 수정 기능
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('수정', style: TextStyle(fontSize: 20),),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // 삭제 기능
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('삭제', style: TextStyle(fontSize: 20),),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ))
        ],
      ),
    ),
  );}
}