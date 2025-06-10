import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class UserFood extends StatelessWidget {
  const UserFood({super.key});

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.find<VmHandlerTemp>();
    vmHandler.fetchItemList();
    var filteredListbyMainMenu =
        vmHandler.itemList
            .where(
              (item) =>
                  item['menuCode'] != null &&
                  item['menuCode'].toString().startsWith('M'),
            )
            .toList(); // 앞글자 구분해서 mainmenu 가져오기
    return Scaffold(
      body: Obx(() {
        return vmHandler.itemList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
              itemCount: filteredListbyMainMenu.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final s = filteredListbyMainMenu[index];
                // null 체크 및 기본값 처리
                final String base64String = s['menuImage'] ?? '';
                final String menuName = s['menuName'] ?? '이름 없음';
                final String menuPrice = s['menuPrice']?.toString() ?? '가격 없음';
                Uint8List? imageBytes;
                try {
                  imageBytes =
                      base64String.isNotEmpty
                          ? base64Decode(base64String)
                          : null;
                } catch (e) {
                  imageBytes = null;
                }
                return GestureDetector(
                  onTap: () {
                    vmHandler.selectItemForDrawer(s); // VmHandler에 선택된 항목 저장
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child:
                              imageBytes == null
                                  ? Icon(Icons.image_not_supported)
                                  : Image.memory(imageBytes, fit: BoxFit.cover),
                        ),
                        Text(menuName),
                        Text(menuPrice),
                      ],
                    ),
                  ),
                );
              },
            );
      }),
    );
  }
}
