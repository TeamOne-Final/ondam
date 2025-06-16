import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ondam_app/model/movingobject.dart';
import 'package:ondam_app/view/chatting/chatroomview.dart';
import 'package:ondam_app/view/chatting/messageview.dart';
import 'package:ondam_app/vm/chat_controller_firebase.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class TableSelect extends StatelessWidget {
  TableSelect({super.key});
  final tableController = Get.find<Chatcontroller>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = Get.find<VmHandlerTemp>();
  final box = GetStorage();


  @override
  Widget build(BuildContext context) {
    
    final int value = Get.arguments as int;
    final String storeCode = box.read("companyCode");
    final String mytableName =value.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.fetchObjects(storeCode);
  });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "$mytableName번 테이블",
          style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Get.to(() => Chatroomview(), arguments: [
                mytableName,
                tableController.rId.value,
              ]);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator());
        } else if (controller.loadedObjects.isEmpty) {
          return  Center(
            child: Text('저장된 데이터가 없습니다.', style: TextStyle(color: Colors.white)),
          );
        } else {
          return Stack(
            children: controller.loadedObjects.map((obj) {
              final isSelected = obj.tableNum.toString() == mytableName;

              return Positioned(
                left: obj.xCoordinate,
                top: obj.yCoordinate,
                child: GestureDetector(
                  onTap: isSelected
                      ? null
                      : () async {
                          await tableController.creatRoom(
                            int.parse(mytableName),
                            obj.tableNum.toString(),
                          );

                          await _firestore
                              .collection("chatroom")
                              .doc(tableController.rId.value)
                              .update({"state": 0});

                          Get.to(() => Messageview(), arguments: [
                            mytableName,
                            obj.tableNum,
                            tableController.rId.value,
                          ]);
                        },
                  child: Container(
                    width: MovingObject.objectWidth,
                    height: MovingObject.objectHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(
                          isSelected
                              ? "images/white.png"
                              : "images/wood.jpg",
                        ),
                        fit: BoxFit.cover,
                        opacity: isSelected ? 0.3 : 1.0,
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          offset:  Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isSelected
                          ? Text(mytableName,style: TextStyle(fontSize: 25),)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${obj.tableNum}번 테이블",
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Icon(Icons.people, color: Colors.white70),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      }),
    );
  }
}