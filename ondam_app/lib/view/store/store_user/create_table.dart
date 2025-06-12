import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/model/movingobject.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CreateTable extends StatelessWidget {
  const CreateTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VmHandlerTemp());
    final screenSize = MediaQuery.of(context).size;
    final box = GetStorage();
    String managerId = '';
    String companyCode = '';
    managerId = box.read('mid') ?? 'Unknown';
    companyCode = box.read('companyCode') ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: Text('물체 충돌/경계/선택')),
      floatingActionButton: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (controller.selectedId.value != null) ...[
              FloatingActionButton(
                heroTag: 'delete',
                backgroundColor: Colors.red,
                onPressed: controller.removeSelectedObject,
                child: Icon(Icons.delete),
              ),
              SizedBox(width: 12),
            ],
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                controller.addObject(const Offset(50, 50));
              },
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: 'save', // 고유한 heroTag
              backgroundColor: Colors.green, // 저장 버튼 색상
              onPressed: () {
                // 컨트롤러의 saveObjectsToDatabase 메서드 호출
                controller.saveObjectsToDatabase(companyCode, managerId);
              },
              child: Icon(Icons.save), // 저장 아이콘
            ),
          ],
        );
      }),
      body: Obx(() {
        return GestureDetector(
          onDoubleTap: controller.clearSelection,
          child: Stack(
            children:
                controller.objects.asMap().entries.map((entry) {
                  // asmap().entries는 리스트를 순회하며 각 요소와 그 인덱스를 MapEntry형태로 준다 테이블 번호 부여를 위해 index 받아오기위해 사용
                  return Obx(() {
                    final index = entry.key; // index 받아오기
                    final obj = entry.value; // 리스트 가져오기
                    final pos = obj.position.value; // 위치정보 저장
                    final isSelected =
                        controller.selectedId.value == obj.id; // 선택한 객체 번호
                    final tableNum = index + 1; // 테이블 번호 설정하기
                    return Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onLongPress: () {
                              controller.selectObject(obj.id);
                            },
                            onPanUpdate: (details) {
                              controller.updatePosition(
                                obj.id,
                                details.delta,
                                screenSize,
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: MovingObject.objectWidth,
                                  height: MovingObject.objectHeight,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.orange
                                            : Colors.blue,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(tableNum.toString()),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  });
                }).toList(),
          ),
        );
      }),
    );
  }
}
