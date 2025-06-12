// 테이블 선택해주는 페이지
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/model/movingobject.dart';
import 'package:ondam_app/view/store/store_user/user_main.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class TableSelect extends StatelessWidget {
  const TableSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VmHandlerTemp());

    return Scaffold(
      appBar: AppBar(title: Text('테이블 선택')),
      body: Obx(() {
        // 로딩 중일 때 로딩 인디케이터 표시
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // 불러온 데이터가 없을 때 메시지 표시
        else if (controller.loadedObjects.isEmpty) {
          return Center(child: Text('저장된 데이터가 없습니다.'));
        }
        // 데이터가 있을 때 객체들을 화면에 표시
        else {
          return Stack(
            children:
                controller.loadedObjects.map((obj) {
                  // Positioned 위젯을 사용하여 불러온 좌표에 객체 배치
                  return Positioned(
                    left: obj.xCoordinate,
                    top: obj.yCoordinate,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => UserMain(), arguments: [obj.tableNum]);
                      },
                      child: Container(
                        // MovingObject에서 정의한 객체 크기 재사용
                        width: MovingObject.objectWidth,
                        height: MovingObject.objectHeight,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          // 객체 중앙에 tableNum 표시
                          child: Text(
                            obj.tableNum.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(), // Map 결과를 List로 변환
          );
        }
      }),
    );
  }
}
