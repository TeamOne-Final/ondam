// lib/controller/load_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ondam_app/model/loaded_object.dart';
import 'package:ondam_app/vm/gender_ratio_controller.dart';

class LoadController extends GenderRatioController {
  // 불러온 객체 목록을 담을 Observable 리스트
  var loadedObjects = <LoadedObject>[].obs;
  // 데이터 로딩 중인지 나타내는 Observable 변수
  var isLoading = true.obs;

  // 백엔드 API에서 객체 데이터를 불러오는 비동기 메서드
  Future<void> fetchObjects(String companyCode) async {
    String baseUrl = 'http://127.0.0.1:8000';

    isLoading.value = true; // 로딩 시작

    try {
      final url = Uri.parse(
        '$baseUrl/inhwan/get_objects?companyCode=$companyCode',
      ); // <-- URL 수정

      final response = await http.get(url); // <-- 수정된 URL 사용

      if (response.statusCode == 200) {
        // 응답 본문을 JSON으로 파싱
        // 서버에서 리스트 형태의 JSON을 반환.
        final dynamic jsonResponse = jsonDecode(
          response.body,
        ); // dynamic으로 받아서 타입 체크
        // 응답이 예상대로 List 형태인지 확인합니다.
        if (jsonResponse is List) {
          // JSON 리스트를 LoadedObject 객체 리스트로 변환하여 loadedObjects에 할당
          loadedObjects.value =
              jsonResponse.map((data) => LoadedObject.fromJson(data)).toList();
        } else {
          // List가 아닌 다른 형태 (예: 오류 메시지 Map)가 왔을 경우 처리
          print('서버 응답이 예상한 List 형태가 아닙니다: $jsonResponse');
          // 사용자에게 오류 알림
          Get.snackbar('로드 실패', '서버 응답 형식이 올바르지 않습니다.');
          loadedObjects.clear(); // 기존 데이터 초기화
        }
      } else {
        // 서버 응답이 실패 (200 OK가 아님)일 경우
        print('데이터 로드 실패 상태 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}'); // 오류 응답 본문 확인
        Get.snackbar(
          '로드 실패',
          '데이터를 불러오는데 실패했습니다: 상태 코드 ${response.statusCode}',
        );
        loadedObjects.clear(); // 오류 발생 시 데이터 초기화
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생 시
      Get.snackbar('로드 실패', '데이터 로드 중 오류가 발생했습니다: ${e.toString()}');
      print('데이터 로드 중 예외 발생: $e');
      loadedObjects.clear(); // 오류 발생 시 데이터 초기화
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }
}
