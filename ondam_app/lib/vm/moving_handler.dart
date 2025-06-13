// moving_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondam_app/model/movingobject.dart';
import 'package:ondam_app/vm/loadcontroller.dart';

class MovingController extends LoadController {
  var objects = <MovingObject>[].obs; // 움직이는 객체들 담는 리스트
  var selectedId = RxnInt(); // 고른 id
  var _idCounter = 0; // 아이디 autoincrement

  void addObject(Offset position) {
    objects.add(MovingObject(id: _idCounter++, initialPosition: position));
  }

  void removeSelectedObject() {
    final id = selectedId.value;
    if (id != null) {
      objects.removeWhere((obj) => obj.id == id);
      selectedId.value = null;
    }
  }

  void updatePosition(int id, Offset delta, Size screenSize) {
    final obj = objects.firstWhereOrNull(
      (o) => o.id == id,
    ); // firstWhereOrNull id못찾으면 null 반환
    if (obj == null) return;

    final current = obj.position.value; // 가져온 위치정보를 현재위치로 저장
    Offset newPos = current + delta; // 현재 위치에 이동거리 더해서 새로운위치 저장

    // 화면 경계 체크
    newPos = Offset(
      newPos.dx.clamp(
        0.0,
        screenSize.width - MovingObject.objectWidth,
      ), // x좌표가 0.0 과 화면 너비에서 객체크기를 뺀값 오른쪽 경계에 못가게막는다
      newPos.dy.clamp(0.0, screenSize.height - MovingObject.objectHeight),
    );

    // 충돌 감지
    final newRect = Rect.fromLTWH(
      // 이동하려는 새로운 위치(newpos)에 객체가 있을떄 차지할 영역을 계산
      newPos.dx,
      newPos.dy,
      MovingObject.objectWidth,
      MovingObject.objectHeight,
    );
    final hasCollision = objects.any((other) {
      //object 리스트에 다른 모든객체를 확인해서 충돌있는지 확인
      if (other.id == id) return false; // 자기 자신이 아이디확인해서 제외
      return newRect.overlaps(
        other.getRect(),
      ); // 이동하려는 새로운 사각형 영역이 리스트의 다른 객체의 사각형 영역(other.getRext())과 겹치는지 overlaps()확인 겹치면 true 반환
    });

    if (!hasCollision) {
      // 충돌이 없을경우
      obj.position.value =
          newPos; // 계산된 새로운 위치 반환 충돌이 발생하면 위치 업데이트가 이루어지지않아 객체가 겹치는거 방지
    }
  }

  void selectObject(int id) {
    selectedId.value = id;
  }

  void clearSelection() {
    selectedId.value = null;
  }

  Future<void> saveObjectsToDatabase(String code, String id) async {
    // 백엔드 FastAPI 서버 주소 (FastAPI 코드에서 설정한 주소와 포트)
    const String baseUrl = 'http://127.0.0.1:8000';

    try {
      // 1. 기존 데이터 삭제 요청
      final deleteResponse = await http.post(
        Uri.parse('$baseUrl/inhwan/delete?code=$code'),
      );

      if (deleteResponse.statusCode == 200) {
        // 2. 새로운 데이터 삽입 요청
        // objects 리스트를 순회하며 각 객체의 데이터를 추출하고 삽입 요청 보냄
        for (final entry in objects.asMap().entries) {
          final index = entry.key; // 리스트의 인덱스 (tableNum으로 사용)
          final obj = entry.value; // MovingObject 객체

          // 데이터베이스에 저장할 데이터 형식에 맞게 Map 생성
          final data = {
            'userTable_TableNum': obj.id, // 객체의 고유 ID
            'userTable_CompanyCode': code,
            'manager_managerId': id,
            'date': DateTime.now().toString(),
            'x': obj.position.value.dx, // 객체의 x 좌표
            'y': obj.position.value.dy, // 객체의 y 좌표
            'tableId': index + 1, // 리스트 인덱스 + 1을 테이블 번호로 사용
          };

          // /insert 엔드포인트에 POST 요청 보냄
          final insertResponse = await http.post(
            Uri.parse('$baseUrl/inhwan/insert'),
            headers: {
              'Content-Type': 'application/json',
            }, // JSON 형식으로 데이터 전송 명시
            body: jsonEncode(data), // Map을 JSON 문자열로 변환하여 body에 담음
          );

          if (insertResponse.statusCode != 200) {
            print(
              '데이터 삽입 실패: ID ${obj.id}, 상태 코드 ${insertResponse.statusCode}',
            );
            // 특정 객체 삽입 실패 시 처리 로직 추가 가능
          } else {
            print('데이터 삽입 성공: ID ${obj.id}');
          }
        }
        print('모든 객체 데이터베이스 저장 완료');

        // 저장 완료 후 사용자에게 알림 등을 표시할 수 있습니다.
        Get.snackbar('저장 완료', '객체 위치 정보가 데이터베이스에 저장되었습니다.');
      } else {
        print('기존 데이터 삭제 실패: 상태 코드 ${deleteResponse.statusCode}');
        print('응답 본문: ${deleteResponse.body}');
        Get.snackbar('저장 실패', '기존 데이터 삭제 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('데이터베이스 저장 중 오류 발생: $e');
      Get.snackbar('저장 실패', '데이터베이스 통신 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
