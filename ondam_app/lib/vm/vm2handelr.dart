import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ondam_app/colors.dart';

class Vm2handelr extends GetxController {
  // 메뉴 목록
  var itemList = <Map<String, dynamic>>[].obs;
  // 메뉴 목록 로딩 상태
  var isLoading = true.obs;

  var maleNum = 0.obs;
  var femaleNum = 0.obs;

  // 장바구니 목록
  var cartItems = <Map<String, dynamic>>[].obs;
  // 장바구니 총 금액
  var totalCartAmount = 0.0.obs;

  // Drawer 상단에 상세 정보를 표시할 선택된 메뉴 항목
  var selectedDrawerItem = Rx<Map<String, dynamic>?>(
    null,
  ); // Drawer 상단 내용 제어를 위해 필요

  // 테이블별 주문 내역 (다이얼로그에서 사용)
  var tableOrderItems = <Map<String, dynamic>>[].obs;
  // 테이블 주문 내역 로딩 상태
  var isTableOrderLoading = false.obs;

  // FastAPI 서버 주소 (임시)
  final String baseUrl = 'http://127.0.0.1:8000';

  @override
  void onInit() {
    super.onInit();
    // 장바구니 변경 시 총 금액 자동 계산
    ever(cartItems, (_) => _calculateTotalAmount());
  }

  // 메뉴 데이터 가져오기
  Future<void> fetchItemList() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$baseUrl/inhwan/get_products'),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic decodedData = json.decode(responseBody);

        if (decodedData is List) {
          itemList.assignAll(decodedData.cast<Map<String, dynamic>>());
          print('메뉴 데이터 로드 성공: ${itemList.length} 개');
        } else {
          print('메뉴 데이터 형식이 예상과 다릅니다: ${decodedData.runtimeType}');
          String errorMessage = '서버에서 예상치 못한 형식의 응답을 받았습니다.';
          if (decodedData is Map<String, dynamic> &&
              decodedData.containsKey('detail')) {
            errorMessage =
                '서버 오류 (${response.statusCode}): ${decodedData['detail']}';
          }
          Get.snackbar('데이터 오류', errorMessage);
          itemList.clear(); // 오류 발생 시 목록을 비웁니다.
        }
      } else {
        print('메뉴 데이터 로드 실패: ${response.statusCode}');
        final String errorBody = utf8.decode(response.bodyBytes);
        String errorMessage = '서버 오류 (${response.statusCode})';
        try {
          final dynamic errorData = json.decode(errorBody);
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('detail')) {
            errorMessage =
                '서버 오류 (${response.statusCode}): ${errorData['detail']}';
          }
        } catch (e) {
          print('오류 응답 본문 디코딩 실패: $e');
        }
        Get.snackbar('로드 실패', errorMessage);
        itemList.clear(); // 오류 발생 시 목록을 비웁니다.
      }
    } catch (e) {
      print('메뉴 데이터 로드 중 오류 발생: $e');
      Get.snackbar('통신 오류', '메뉴 데이터를 가져오는 중 네트워크 오류가 발생했습니다.');
      itemList.clear(); // 오류 발생 시 목록을 비웁니다.
    } finally {
      isLoading(false);
    }
  }

  void upmaleNum() {
    maleNum++;
    if (maleNum > 10) {
      maleNum.value = 10;
    }
  }

  void upfemaleNum() {
    femaleNum++;
    if (femaleNum > 10) {
      femaleNum.value = 10;
    }
  }

  void downmaleNum() {
    maleNum--;
    if (maleNum < 0) {
      maleNum.value = 0;
    }
  }

  void downfemaleNum() {
    femaleNum--;
    if (femaleNum < 0) {
      femaleNum.value = 0;
    }
  }

  // Drawer 상단에 표시할 항목 선택
  void selectItemForDrawer(Map<String, dynamic> item) {
    selectedDrawerItem(item); // 이 함수 호출 시 Drawer 상단에 상세 정보가 표시됩니다.
  }

  // Drawer 상단 선택 항목 초기화
  void clearSelectedItemForDrawer() {
    selectedDrawerItem(null); // 이 함수 호출 시 Drawer 상단 상세 정보가 사라집니다.
  }

  // 장바구니에 항목 추가 (수량 1 증가)
  void addToCart(Map<String, dynamic> menuItem) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item['menuCode'] == menuItem['menuCode'],
    );

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex]['quantity']++;
      cartItems.refresh();
    } else {
      final itemToAdd = Map<String, dynamic>.from(menuItem);
      itemToAdd['quantity'] = 1;
      if (!itemToAdd.containsKey('price_at_order')) {
        itemToAdd['price_at_order'] = itemToAdd['menuPrice'];
      }
      cartItems.add(itemToAdd);
    }
  }

  // 장바구니 항목 수량 증가
  void increaseQuantity(Map<String, dynamic> menuItem) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item['menuCode'] == menuItem['menuCode'],
    );
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex]['quantity']++;
      cartItems.refresh();
    }
  }

  // 장바구니 항목 수량 감소
  void decreaseQuantity(Map<String, dynamic> menuItem) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item['menuCode'] == menuItem['menuCode'],
    );
    if (existingItemIndex != -1) {
      if (cartItems[existingItemIndex]['quantity'] > 1) {
        cartItems[existingItemIndex]['quantity']--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(existingItemIndex);
      }
    }
  }

  // 장바구니 총 금액 계산
  void _calculateTotalAmount() {
    double total = 0.0;
    for (var item in cartItems) {
      total +=
          (item['price_at_order'] as num? ?? 0.0) *
          (item['quantity'] as int? ?? 0);
    }
    totalCartAmount(total);
  }

  // 주문하기 (장바구니 내용을 purchase 테이블에 삽입)
  Future<void> placeOrder(
    String tableNumber,
    String companyCode,
    int maleNum,
    int femaleNum,
  ) async {
    if (cartItems.isEmpty) {
      Get.snackbar('알림', '장바구니가 비어있습니다.',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }

    final String tranDate = DateTime.now().toIso8601String();

    List<Map<String, dynamic>> orderItemsData =
        cartItems.map((item) {
          return {
            'tableNum': tableNumber,
            'companyCode': companyCode,
            'menuCode': item['menuCode'],
            'tranDate': tranDate,
            'femaleNum': femaleNum,
            'maleNum': maleNum,
            'quantity': item['quantity'],
            'currentState': '주문', // 초기 상태는 '주문'
            'price_at_order': item['price_at_order'],
          };
        }).toList();

    try {
      // FastAPI 서버의 주문 엔드포인트로 데이터 전송
      final response = await http.post(
        Uri.parse('$baseUrl/inhwan/place_order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderItemsData),
      );

      if (response.statusCode == 200) {
        Get.snackbar('주문 완료', '주문이 성공적으로 접수되었습니다.',colorText: backgroundColor,backgroundColor: Colors.green);
        cartItems.clear(); // 장바구니 비우기
        clearSelectedItemForDrawer(); // 주문 완료 후 Drawer 닫기 및 선택 항목 초기화
        Get.back(); // Drawer 닫기 (만약 열려있다면)
      } else {
        print('주문 실패: ${response.statusCode}');
        Get.snackbar('주문 실패', '주문 처리 중 오류가 발생했습니다.');
        print('응답 본문: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('주문 전송 중 오류 발생: $e');
      Get.snackbar('주문 오류', '서버와 통신 중 오류가 발생했습니다.');
    }
  }

  // --- 테이블 주문 내역 관련 함수 (LoadPage2 다이얼로그에서 사용) ---

  // 특정 테이블의 '주문' 상태인 주문 항목 가져오기
  Future<void> fetchTableOrderItems(String tableNum, String companyCode) async {
    try {
      isTableOrderLoading(true);
      tableOrderItems.clear(); // 기존 목록 초기화

      // FastAPI 서버의 새로운 엔드포인트 호출
      final response = await http.get(
        Uri.parse('$baseUrl/inhwan/get_table_orders/$tableNum/$companyCode'),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic decodedData = json.decode(responseBody);

        if (decodedData is List) {
          tableOrderItems.assignAll(decodedData.cast<Map<String, dynamic>>());
          print('$tableNum 번 테이블 주문 내역 로드 성공: ${tableOrderItems.length} 개');
        } else {
          print('테이블 주문 내역 데이터 형식이 예상과 다릅니다: ${decodedData.runtimeType}');
          String errorMessage = '서버에서 예상치 못한 형식의 응답을 받았습니다.';
          if (decodedData is Map<String, dynamic> &&
              decodedData.containsKey('detail')) {
            errorMessage = '서버 오류: ${decodedData['detail']}';
          }
          Get.snackbar('데이터 오류', errorMessage);
          tableOrderItems.clear();
        }
      } else {
        print('테이블 주문 내역 로드 실패: ${response.statusCode}');
        final String errorBody = utf8.decode(response.bodyBytes);
        String errorMessage = '서버 오류 (${response.statusCode})';
        try {
          final dynamic errorData = json.decode(errorBody);
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('detail')) {
            errorMessage =
                '서버 오류 (${response.statusCode}): ${errorData['detail']}';
          }
        } catch (e) {
          print('오류 응답 본문 디코딩 실패: $e');
        }
        Get.snackbar('로드 실패', errorMessage);
        tableOrderItems.clear();
      }
    } catch (e) {
      print('테이블 주문 내역 로드 중 오류 발생: $e');
      Get.snackbar('통신 오류', '테이블 주문 내역을 가져오는 중 네트워크 오류가 발생했습니다.');
      tableOrderItems.clear();
    } finally {
      isTableOrderLoading(false);
    }
  }

  // 특정 테이블의 '주문' 상태인 주문 항목 상태를 '결제완료'로 업데이트
  Future<void> updateOrderStateToCompleted(
    String tableNum,
    String companyCode,
  ) async {
    if (tableOrderItems.isEmpty) {
      Get.snackbar('알림', '결제할 주문 내역이 없습니다.');
      return;
    }

    try {
      // FastAPI 서버의 새로운 엔드포인트 호출
      // 해당 테이블의 '주문' 상태 항목들을 '결제완료'로 변경 요청
      final response = await http.put(
        // PUT 또는 PATCH 요청 사용
        Uri.parse(
          '$baseUrl/inhwan/update_order_state_to_completed/$tableNum/$companyCode',
        ),
        headers: {'Content-Type': 'application/json'},
        // 필요한 경우 요청 본문에 추가 데이터 포함 가능 (예: 결제 방식 등)
        // body: json.encode({'state': '결제완료'}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('결제 완료', '$tableNum 번 테이블 주문이 결제 완료되었습니다.');
        tableOrderItems.clear(); // 결제 완료 후 목록 초기화
      } else {
        print('결제 실패: ${response.statusCode}');
        Get.snackbar('결제 실패', '결제 처리 중 오류가 발생했습니다.');
        print('응답 본문: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('결제 전송 중 오류 발생: $e');
      Get.snackbar('결제 오류', '서버와 통신 중 오류가 발생했습니다.');
    }
  }

  // 다이얼로그 닫을 때 테이블 주문 목록 초기화
  void clearTableOrderItems() {
    tableOrderItems.clear();
  }
}
