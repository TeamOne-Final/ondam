import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/colors.dart';
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
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('테이블 배치하기',style: TextStyle(color: backgroundColor,fontWeight: FontWeight.bold),),backgroundColor: mainColor,iconTheme: IconThemeData(color: backgroundColor),),
      floatingActionButton: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (controller.selectedId.value != null) ...[
              FloatingActionButton(
                heroTag: 'delete',
                backgroundColor: Colors.red,
                onPressed: controller.removeSelectedObject,
                child: Icon(Icons.delete,color: backgroundColor,),
              ),
              SizedBox(width: 12),
            ],
            Padding(
              padding: const EdgeInsets.only(left:5),
              child: FloatingActionButton(
                heroTag: 'add',
                backgroundColor:  mainColor,
                foregroundColor: backgroundColor,
                onPressed: () {
                  controller.addObject(const Offset(50, 50));
                },
                child: Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                heroTag: 'save', // 고유한 heroTag
                backgroundColor: Colors.teal, // 저장 버튼 색상
                onPressed: () {
                  // 컨트롤러의 saveObjectsToDatabase 메서드 호출
                  controller.saveObjectsToDatabase(companyCode, managerId);
                },
                child: Icon(Icons.save,color: backgroundColor,), // 저장 아이콘
              ),
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
                                            ? Colors.red
                                            : mainColor,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(tableNum.toString(),style: TextStyle(color: backgroundColor,fontWeight: FontWeight.bold),),
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
