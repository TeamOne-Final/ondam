/* 본사 메뉴 관리
2025.06.10 11:52 이학현 | 메뉴 추가&수정 기능 추가
*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CompanyItem extends StatelessWidget {
  CompanyItem({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();
  final items = ['전체', '메인메뉴', '사이드메뉴', '음료', '추가옵션'];

  @override
  Widget build(BuildContext context) {
    TextEditingController itemCodeController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemDescriptionController = TextEditingController();
    TextEditingController itemPriceController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          // CompanySideMenu(), // 화면 구조 변경으로 안 씀
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                    child: Text('메뉴관리', style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                  ),
                  Obx(() => 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,15,0,0),
                    child: DropdownButton(
                      value: controller.selectedMenuList.value.isEmpty ? null : controller.selectedMenuList.value,
                      hint: Text('메뉴선택', style: TextStyle(fontSize: 25),),
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item, style: TextStyle(color: Colors.black, fontSize: 25),),
                        );
                      },).toList(), 
                      onChanged: (value) {
                        controller.valueToMenuCode1(value!);
                      },
                    ),
                  ),
                  ),
                  Spacer(),

                  // ######## 메뉴 추가 ########
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 70, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor:mainColor),
                      onPressed: () async{
                        // final image = controller.imageFile.value; // obx 때문에 안 쓰게 됨
                        itemCodeController.clear();
                        itemNameController.clear();
                        itemDescriptionController.clear();
                        itemPriceController.clear();
                    
                        await Get.defaultDialog(
                          barrierDismissible: false,
                          title: '메뉴 추가',
                            titleStyle: TextStyle(fontSize: 30),
                            titlePadding: EdgeInsets.all(40),
                          content: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // print('탭됨'); // 테스트용
                                    controller.getImageFromGallery(ImageSource.gallery);
                                  },
                                  child: Obx(() => 
                                  Container(
                                    child: controller.firstDisp.value == 0
                                      ? Icon(Icons.image_not_supported, size: 200)
                                      : Image.file(File(controller.imageFile.value!.path), width: 200, height: 200, fit: BoxFit.cover,),
                                    )
                                  ,) 
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('메뉴 코드 : ', style: TextStyle(fontSize: 20),),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: itemCodeController,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('메뉴 이름 : ', style: TextStyle(fontSize: 20),),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: itemNameController,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('메뉴 설명 : ', style: TextStyle(fontSize: 20),),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 10,
                                          controller: itemDescriptionController,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('메뉴 가격 : ', style: TextStyle(fontSize: 20),),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: itemPriceController,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 40, 30, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                                        onPressed: () {
                                          String code = itemCodeController.text;
                                          String name = itemNameController.text;
                                          String description = itemDescriptionController.text;
                                          String price = itemPriceController.text;
                                          if (controller.firstDisp.value > 0&&name.isNotEmpty&&description.isNotEmpty&&price.isNotEmpty&&int.tryParse(price)!=null){
                                            controller.insertItem(code, name, description, price, controller.imageFile.value!.path, controller.firstDisp.value,);
                                            controller.firstDisp.value = 0;
                                          }else if(controller.firstDisp.value == 0){
                                            Get.snackbar('메뉴 추가 실패', '이미지를 선택해 주세요', titleText: Text('메뉴 추가 실패',style: TextStyle(fontSize: 30, color: Colors.white),), messageText: Text('이미지를 선택해 주세요', style: TextStyle(fontSize: 24, color: Colors.white),), backgroundColor: Colors.redAccent, colorText: Colors.white, maxWidth: MediaQuery.sizeOf(context).width/2, duration: Duration(seconds: 1));
                                          }else{
                                            Get.snackbar('메뉴 추가 실패', '입력한 내용을 다시 확인해 주세요', titleText: Text('메뉴 추가 실패',style: TextStyle(fontSize: 30, color: Colors.white),), messageText: Text('입력한 내용을 다시 확인해 주세요', style: TextStyle(fontSize: 24, color: Colors.white),), backgroundColor: Colors.redAccent, colorText: Colors.white, maxWidth: MediaQuery.sizeOf(context).width/2, duration: Duration(seconds: 1));
                                          }
                                        }, 
                                        child: Text('추가', style: TextStyle(fontSize: 24, color: Colors.white)),
                                      ),
                                      ElevatedButton( 
                                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(46, 61, 83, 1)),
                                        onPressed: () {
                                          Get.back();
                                          controller.firstDisp.value = 0;
                                        },
                                        child: Text('취소', style: TextStyle(fontSize: 24, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        );
                      }, 
                      child: Text('메뉴 추가', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                ],
              ),

              // ######## 메뉴 리스트 뷰 ########
              Obx(() => 
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  itemCount: controller.itemList.length,
                  itemBuilder: (context, index) {
                    final item = controller.itemList[index];
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                      color: Colors.white, // 배경 색
                      borderRadius: BorderRadius.circular(16), // 모서리 둥글게
                      boxShadow: [ // 그림자 효과
                        BoxShadow(
                          color: Colors.grey.withAlpha((255 * 0.2).round()),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300), // 연한 테두리
                          ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item['menuImage'] != null && item['menuImage'].toString().isNotEmpty
                                  ? Image.memory(
                                      base64Decode(item['menuImage']),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image_not_supported, size: 150),
                            ),
                            SizedBox(width: 20),
                            // 이름과 가격
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['menuName'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text(item['description'], style: TextStyle(fontSize: 22, color: Colors.black54, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text("₩${item['menuPrice']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            // 버튼들
                            Row(
                              children: [
                                // ######## 메뉴 수정 ########
                                ElevatedButton(
                                  onPressed: () async{
                                    itemNameController.text = item['menuName'];
                                    itemDescriptionController.text = item['description'];
                                    itemPriceController.text = item['menuPrice'].toString();

                                    await Get.defaultDialog(
                                      barrierDismissible: false,
                                      title: '메뉴 수정',
                                      titleStyle: TextStyle(fontSize: 30),
                                      titlePadding: EdgeInsets.fromLTRB(40, 40, 40, 20),
                                      content: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Column(
                                          children: [
                                            // item['menuImage'] != null && item['menuImage'].toString().isNotEmpty
                                              // ? Image.memory(
                                              //     base64Decode(item['menuImage']),
                                              //     width: 80,
                                              //     fit: BoxFit.cover,
                                              //   )
                                            //   : Icon(Icons.image_not_supported, size: 80),
                                              GestureDetector(
                                                onTap: () {
                                                  // print('탭됨');
                                                  controller.getImageFromGallery(ImageSource.gallery);
                                                },
                                                child: Obx(() => 
                                                Container(
                                                  child: controller.firstDisp.value == 0? 
                                                    controller.itemList[index]['menuImage'] == null ?
                                                    Icon(Icons.image_not_supported, size: 200):
                                                    Image.memory(
                                                        base64Decode(controller.itemList[index]['menuImage']),
                                                        width: 200,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(File(controller.imageFile.value!.path), width: 200, height: 200, fit: BoxFit.cover,),
                                                  )
                                                ,) 
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('메뉴 이름 : ', style: TextStyle(fontSize: 20),),
                                                  SizedBox(
                                                    width: 200,
                                                    child: TextField(
                                                      controller: itemNameController,
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('메뉴 설명 : ', style: TextStyle(fontSize: 20),),
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    minLines: 1,
                                                    maxLines: 10,
                                                    controller: itemDescriptionController,
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('메뉴 가격 : ', style: TextStyle(fontSize: 20),),
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller: itemPriceController,
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 98, 234, 83)),
                                                    onPressed: () {
                                                      String code = item['menuCode'];
                                                      String name = itemNameController.text;
                                                      String description = itemDescriptionController.text;
                                                      String price = itemPriceController.text;
                                                      if(name.isNotEmpty&&description.isNotEmpty&&price.isNotEmpty&&int.tryParse(price)!=null){
                                                        controller.updateItem(code, name, description, price, controller.imageFile.value!.path, controller.firstDisp.value);
                                                        controller.firstDisp.value = 0;
                                                      }else{
                                                        Get.snackbar('수정 실패', '입력한 내용을 다시 확인해 주세요', titleText: Text('수정 실패',style: TextStyle(fontSize: 30, color: Colors.white),), messageText: Text('입력한 내용을 다시 확인해 주세요', style: TextStyle(fontSize: 24, color: Colors.white),), backgroundColor: Colors.redAccent, colorText: Colors.white, maxWidth: MediaQuery.sizeOf(context).width/2, duration: Duration(seconds: 1));
                                                      }
                                                    }, 
                                                    child: Text('수정', style: TextStyle(fontSize: 24, color: Colors.black)),
                                                  ),
                                                  ElevatedButton( 
                                                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(46, 61, 83, 1)),
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.firstDisp.value = 0;
                                                    },
                                                    child: Text('취소', style: TextStyle(fontSize: 24, color: Colors.white)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('수정', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(width: 8),

                                // ######## 메뉴 삭제 ########
                                ElevatedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: '선택한 메뉴를 삭제하시겠습니까?',
                                      titleStyle: TextStyle(fontSize: 30),
                                      titlePadding: EdgeInsets.all(40),
                                      content: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () => controller.deleteItem(item['menuCode']), 
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('삭제', style: TextStyle(fontSize: 24, color: Colors.white),),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Get.back(), 
                                                style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(46, 61, 83, 1)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('취소', style: TextStyle(fontSize: 24, color: Colors.white),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('삭제', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ) 
            ],
          ))
        ],
      ),
    );
  }
}