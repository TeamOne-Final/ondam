// 고객 메인 페이지
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/view/store/store_user/user_main_category/additional_menu.dart';
import 'package:ondam_app/view/store/store_user/user_main_category/user_drink.dart';
import 'package:ondam_app/view/store/store_user/user_main_category/user_food.dart';
import 'package:ondam_app/view/store/store_user/user_main_category/user_liquor.dart';
import 'package:ondam_app/vm/side_menu_controller.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class UserMain extends StatelessWidget {
  UserMain({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vmHandler.isEndDrawerOpen.value) {
        final scaffold = Scaffold.of(context);
        if (scaffold.hasEndDrawer) {
          scaffold.openEndDrawer();
          // Drawer가 열린 후에는 상태를 다시 false로 변경하여 반복해서 열리지 않도록 합니다.
          // vmHandler.isEndDrawerOpen.value = false; // openDrawer() 호출 후 바로 닫히지 않도록 여기에 두지 않습니다.
        } else {
          print("UserMain build: Scaffold does NOT have endDrawer.");
        }
      }
    });

    var value = Get.arguments ?? "__";
    String tableNum = value[0].toString();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // 오른쪽 drawer 아이콘 변경하기
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Obx(() {
          final selectedItem = vmHandler.selectedDrawerItem.value;
          if (selectedItem == null) {
            return ListView(
              padding: EdgeInsets.zero,
              children: const [
                DrawerHeader(
                  // 간단한 헤더
                  decoration: BoxDecoration(color: Colors.redAccent),
                  child: Center(
                    child: Text(
                      '항목을 선택해주세요',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                // 여기에 Drawer의 기본 메뉴 항목 등을 추가할 수 있습니다.
                ListTile(title: Text('기본 메뉴 1')),
                ListTile(title: Text('기본 메뉴 2')),
              ],
            );
          } else {
            // 선택된 항목이 있을 경우 해당 항목 상세 정보 표시
            final String base64String = selectedItem['menuImage'] ?? '';
            final String menuName = selectedItem['menuName'] ?? '이름 없음';
            final String menuPrice =
                selectedItem['menuPrice']?.toString() ?? '가격 없음';
            Uint8List? imageBytes;
            final String menuDescription = selectedItem['description'] ?? "";
            try {
              imageBytes =
                  base64String.isNotEmpty ? base64Decode(base64String) : null;
            } catch (e) {
              print('Error decoding base64 image for drawer: $e');
              imageBytes = null;
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  // 사용자 계정 헤더 또는 커스텀 헤더 사용
                  accountName: Text(menuName), // 항목 이름으로 사용
                  accountEmail: Text('가격: $menuPrice'), // 항목 가격으로 사용
                  currentAccountPicture:
                      imageBytes == null
                          ? Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.white,
                          ) // 이미지가 없으면 아이콘
                          : Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                          ), // 이미지가 있으면 표시
                  decoration: BoxDecoration(
                    color: Colors.blue, // Drawer 헤더 색상
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                // 여기에 항목의 추가 상세 정보를 보여주는 위젯들을 추가할 수 있습니다.
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(menuDescription),
                ),
                // 예: 항목 설명 등
                // ListTile(
                //     leading: Icon(Icons.description),
                //     title: Text('이 항목은 매우 맛있습니다!')
                // ),
                Divider(), // 구분선
                ListTile(
                  // Drawer 닫기 버튼 (옵션)
                  leading: Icon(Icons.close),
                  title: Text('닫기'),
                  onTap: () {
                    Get.back(); // GetX를 사용하여 Drawer 닫기
                    // vmHandler.clearSelectedDrawerItem(); // 닫을 때 선택 항목 초기화 (선택 사항)
                  },
                ),
              ],
            );
          }
        }),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(22, 30, 40, 1),
              ),
              child: ListView(
                children: [
                  Image.asset('images/ondamlogo.png', height: 295),
                  Text(
                    '$tableNum 번 테이블',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  _buildTile(vmHandler, 0, '안주'),
                  _buildTile(vmHandler, 1, '주류'),
                  _buildTile(vmHandler, 2, '음료'),
                  _buildTile(vmHandler, 3, '추가 메뉴'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Obx(() {
              switch (vmHandler.selectedIndex.value) {
                case 0:
                  return UserFood();
                case 1:
                  return UserLiquor();
                case 2:
                  return UserDrink();
                case 3:
                  return AdditionalMenu();
                default:
                  return Center(child: Text('페이지를 선택해 주세요'));
              }
            }),
          ),
        ],
      ),
    );
  } // build

  // Widgets
  Widget _buildTile(SideMenuController vmHandler, int index, String title) {
    return Obx(() {
      final isSelected = vmHandler.selectedIndex.value == index;

      return Container(
        color:
            isSelected
                ? Color(0xFFF6F7FB)
                : const Color.fromRGBO(22, 30, 40, 1),
        child: ListTile(
          onTap: () {
            vmHandler.select(index);
          },
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      );
    });
  }
}
