// 고객 메인 페이지
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/view/chatting/tableview.dart';
import 'package:ondam_app/vm/side_menu_controller.dart';
import 'package:ondam_app/vm/vm2handelr.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class UserMain extends StatelessWidget {
  UserMain({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();
  final vmHandler2 = Get.find<Vm2handelr>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final int? tableNumberInt = Get.arguments as int?;
    final String? tableNumber = tableNumberInt?.toString();
    final int maleNum = vmHandler2.maleNum.value;
    final int femaleNum = vmHandler2.femaleNum.value;

    String companyCode = box.read('companyCode') ?? 'Unknown';
    // 페이지 로드 시 메뉴 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vmHandler2.fetchItemList();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(tableNumber != null ? '$tableNumber 번 테이블' : '테이블 선택 오류'),
        backgroundColor: const Color.fromRGBO(22, 30, 40, 1),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // 장바구니 아이콘 탭 시: 선택 항목 초기화하고 Drawer 열기 (장바구니 목록 모드)
                  vmHandler2
                      .clearSelectedItemForDrawer(); // 선택 항목을 null로 만들어 상단 상세 정보 비움
                  Scaffold.of(context).openEndDrawer(); // Drawer 열기
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Obx(() {
          // Drawer 내용은 항상 동일한 구조를 가지되, 상단 상세 정보는 selectedDrawerItem에 따라 조건부 표시
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // 상단: 메뉴 상세 정보 (selectedDrawerItem이 null이 아닐 때만 표시)
              if (vmHandler.selectedDrawerItem.value != null)
                _buildMenuItemDetailSection(
                  vmHandler,
                  vmHandler.selectedDrawerItem.value!,
                ),
              // 하단: 장바구니 목록 및 주문/닫기 버튼 (항상 표시)
              _buildCartItemListSection(
                vmHandler,
                tableNumber,
                companyCode,
                maleNum,
                femaleNum,
              ),
            ],
          );
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
                    '$tableNumber 번 테이블',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  _buildTile(vmHandler, 0, '주 메뉴'),
                  _buildTile(vmHandler, 1, '사이드 메뉴'),
                  _buildTile(vmHandler, 2, '주류'),
                  _buildTile(vmHandler, 3, '추가 메뉴'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => vmHandler2.upmaleNum(),
                        icon: Icon(Icons.add),
                      ),
                      Obx(() {
                        final String maleNumString =
                            vmHandler2.maleNum.value.toString();
                        return Text(
                          '남성 \n $maleNumString',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        );
                      }),
                      IconButton(
                        onPressed: () => vmHandler2.downmaleNum(),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => vmHandler2.upfemaleNum(),
                        icon: Icon(Icons.add),
                      ),
                      Obx(() {
                        final String femaleNumString =
                            vmHandler2.femaleNum.value.toString();
                        return Text(
                          '여성 \n $femaleNumString',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        );
                      }),
                      IconButton(
                        onPressed: () => vmHandler2.downfemaleNum(),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                  ),
                Column(
                  children: [
                    Align(
                        alignment: Alignment.center, // 왼쪽 정렬
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 80), // 최소 가로 120, 세로 50
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            Get.to(()=> Tableview(),arguments: tableNumberInt); 
                          },
                          child: Text('채팅'),
                        ),
                      ),
                      SizedBox(height: 20,),
                Align(
                    alignment: Alignment.center, // 왼쪽 정렬
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 80), // 최소 가로 120, 세로 50
                        backgroundColor: const Color.fromARGB(255, 243, 33, 33),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {},
                      child: Text('직원호출'),
                    ),
                  ),
                  ],
                ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Obx(() {
              List filteredListbyMainMenu = [];
              if (vmHandler.selectedIndex == 0) {
                filteredListbyMainMenu =
                    vmHandler.itemList
                        .where(
                          (item) =>
                              item['menuCode'] != null &&
                              item['menuCode'].toString().startsWith('M'),
                        )
                        .toList();
              } else if (vmHandler.selectedIndex == 1) {
                filteredListbyMainMenu =
                    vmHandler.itemList
                        .where(
                          (item) =>
                              item['menuCode'] != null &&
                              item['menuCode'].toString().startsWith('S'),
                        )
                        .toList();
              } else if (vmHandler.selectedIndex == 2) {
                filteredListbyMainMenu =
                    vmHandler.itemList
                        .where(
                          (item) =>
                              item['menuCode'] != null &&
                              item['menuCode'].toString().startsWith('B'),
                        )
                        .toList();
              } else if (vmHandler.selectedIndex == 3) {
                filteredListbyMainMenu =
                    vmHandler.itemList
                        .where(
                          (item) =>
                              item['menuCode'] != null &&
                              item['menuCode'].toString().startsWith('A'),
                        )
                        .toList();
              }

              final menuList = filteredListbyMainMenu;
              if (menuList.isEmpty && vmHandler.isLoading.isTrue) {
                // 로딩 상태도 함께 확인
                return Center(child: CircularProgressIndicator());
              } else if (menuList.isEmpty && !vmHandler.isLoading.isTrue) {
                return Center(child: Text('메뉴 정보를 불러오지 못했습니다.'));
              } else {
                // 메뉴 목록을 GridView로 표시
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: menuList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 3개 항목
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // 항목 비율 조정 (가로/세로)
                  ),
                  itemBuilder: (context, index) {
                    final menu = menuList[index];
                    // null 체크 및 기본값 처리
                    final String base64String = menu['menuImage'] ?? '';
                    final String menuName = menu['menuName'] ?? '이름 없음';
                    final double menuPrice =
                        (menu['menuPrice'] as num?)?.toDouble() ??
                        0.0; // 가격은 double로 처리
                    Uint8List? imageBytes;
                    try {
                      imageBytes =
                          base64String.isNotEmpty
                              ? base64Decode(base64String)
                              : null;
                    } catch (e) {
                      print('Error decoding base64 image for menu item: $e');
                      imageBytes = null;
                    }
                    return GestureDetector(
                      onTap: () {
                        // 메뉴 항목 탭 시: 해당 항목 선택하고 Drawer 열기 (메뉴 상세 모드)
                        vmHandler.selectItemForDrawer(
                          menu,
                        ); // VmHandler에 선택된 항목 저장
                        Scaffold.of(context).openEndDrawer(); // Drawer 열기
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3, // 이미지 영역 비율
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.0),
                                ),
                                child:
                                    imageBytes == null
                                        ? Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey[400],
                                        )
                                        : Image.memory(
                                          imageBytes,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            Expanded(
                              flex: 1, // 텍스트 영역 비율
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menuName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${menuPrice.toStringAsFixed(0)} 원', // 가격 표시 (소수점 제거)
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
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

  // Drawer 상단: 메뉴 상세 정보를 표시하는 위젯 섹션
  Widget _buildMenuItemDetailSection(
    VmHandlerTemp vmHandler,
    Map<String, dynamic> item,
  ) {
    final String base64String = item['menuImage'] ?? '';
    final String menuName = item['menuName'] ?? '이름 없음';
    final double menuPrice = (item['menuPrice'] as num?)?.toDouble() ?? 0.0;
    // description 필드는 product 테이블에 없으므로 임시로 빈 문자열 사용
    final String menuDescription = item['description'] ?? '상세 설명 없음';
    Uint8List? imageBytes;
    try {
      imageBytes = base64String.isNotEmpty ? base64Decode(base64String) : null;
    } catch (e) {
      print('Error decoding base64 image for drawer detail: $e');
      imageBytes = null;
    }

    return Column(
      // Column을 사용하여 여러 위젯을 세로로 배치
      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
          // 헤더 부분
          decoration: BoxDecoration(color: Colors.teal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // 이미지가 헤더 영역을 넘지 않도록 Expanded 사용
                child:
                    imageBytes == null
                        ? Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.white54,
                        )
                        : Image.memory(
                          imageBytes,
                          fit: BoxFit.contain,
                        ), // contain으로 이미지 비율 유지
              ),
              Text(
                menuName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                '${menuPrice.toStringAsFixed(0)} 원',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Padding(
          // 상세 설명 부분
          padding: const EdgeInsets.all(16.0),
          child: Text(menuDescription, style: TextStyle(fontSize: 16)),
        ),
        Divider(), // 구분선
        ListTile(
          // '장바구니에 담기' 버튼
          leading: Icon(Icons.add_shopping_cart),
          title: Text('담기'),
          onTap: () {
            vmHandler2.addToCart(item); // 장바구니에 추가
            Get.snackbar(
              '장바구니 추가',
              '$menuName이(가) 장바구니에 담겼습니다.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        Divider(), // 상세 정보 섹션과 장바구니 섹션 구분선
      ],
    );
  }

  // Drawer 하단: 장바구니 목록 및 주문/닫기 버튼을 표시하는 위젯 섹션
  Widget _buildCartItemListSection(
    VmHandlerTemp vmHandler,
    String? tableNumber,
    String companyCode,
    int maleNum,
    int femaleNum,
  ) {
    final cartItems = vmHandler2.cartItems;

    return Column(
      // Column을 사용하여 여러 위젯을 세로로 배치
      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // 장바구니 목록 헤더
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '장바구니',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          // 총 금액 표시
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Obx(
            () => Text(
              '총 금액: ${vmHandler2.totalCartAmount.toStringAsFixed(0)} 원',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
        Divider(), // 구분선

        if (cartItems.isEmpty) // 장바구니가 비어있을 때 메시지
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('장바구니가 비어있습니다.')),
          )
        else // 장바구니 항목 목록
          ...cartItems.map((item) {
            // 장바구니 항목 위젯 (수량 조절 버튼 포함)
            return ListTile(
              title: Text('${item['menuName']}'),
              subtitle: Text(
                '${(item['price_at_order'] as num? ?? 0.0).toStringAsFixed(0)} 원',
              ), // 단가 표시
              trailing: Row(
                // 수량 조절 버튼과 총 가격 표시
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 수량 감소 버튼
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, size: 20),
                    padding: EdgeInsets.zero, // 패딩 제거
                    constraints: BoxConstraints(), // 제약 조건 제거
                    onPressed: () {
                      vmHandler2.decreaseQuantity(
                        item,
                      ); // VmHandlerTemp의 수량 감소 함수 호출
                    },
                  ),
                  // 현재 수량 표시
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '${item['quantity']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // 수량 증가 버튼
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 20),
                    padding: EdgeInsets.zero, // 패딩 제거
                    constraints: BoxConstraints(), // 제약 조건 제거
                    onPressed: () {
                      vmHandler2.increaseQuantity(
                        item,
                      ); // VmHandlerTemp의 수량 증가 함수 호출
                    },
                  ),
                  SizedBox(width: 8),
                  // 항목별 총 가격 표시
                  Text(
                    '${((item['price_at_order'] as num? ?? 0.0) * (item['quantity'] as int? ?? 0)).toStringAsFixed(0)} 원',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        Divider(), // 구분선
        ListTile(
          // 주문하기 버튼
          leading: Icon(Icons.payment),
          title: Text('주문하기'),
          onTap: () {
            if (tableNumber != null) {
              vmHandler2.placeOrder(
                tableNumber,
                companyCode,
                maleNum,
                femaleNum,
              ); // VmHandlerTemp의 주문 함수 호출
              // placeOrder 함수 내에서 Drawer 닫기 및 장바구니 비우기 처리
            } else {
              Get.snackbar('오류', '테이블 번호를 알 수 없습니다.');
            }
          },
        ),
        ListTile(
          // 닫기 버튼
          leading: Icon(Icons.close),
          title: Text('닫기'),
          onTap: () {
            Get.back(); // Drawer 닫기
            vmHandler2
                .clearSelectedItemForDrawer(); // 닫을 때 선택 항목 초기화 (상태 관리 목적)
          },
        ),
      ],
    );
  }
}
