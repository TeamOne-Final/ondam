// 본사 주문/계약
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CompanyOrder extends StatelessWidget {
  CompanyOrder({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();


  @override
  Widget build(BuildContext context) {
  TextEditingController ingredientCode = TextEditingController();
  TextEditingController factoryCode = TextEditingController();
  TextEditingController companyCode = TextEditingController();
  TextEditingController quantity = TextEditingController();
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
                    child: Text('주문 관리', style: TextStyle(fontSize: 40),),
                  ),
                  Spacer(),

                  // ######## 메뉴 추가 ########
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 220, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 56, 122, 255)),
                      onPressed: () async{
                        ingredientCode.clear();
                        companyCode.clear();
                        factoryCode.clear();
                        quantity.clear();
                        // final image = controller.imageFile.value; // obx 때문에 안 쓰게 됨
                        await Get.defaultDialog(
                          barrierDismissible: false,
                          title: '주문추가',
                            titleStyle: TextStyle(fontSize: 30),
                            titlePadding: EdgeInsets.all(40),
                          content: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('재료 코드 : ', style: TextStyle(fontSize: 20),),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: ingredientCode,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('거래처 코드 : ', style: TextStyle(fontSize: 20),),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: factoryCode,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('지점 코드 : ', style: TextStyle(fontSize: 20),),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: companyCode,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('수량 : ', style: TextStyle(fontSize: 20),),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: quantity,
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
                                                      controller.insertDelivery(factoryCode.text, ingredientCode.text, companyCode.text, int.parse(quantity.text));
                                                      controller.selectorder();
                                                      Get.back();
                                                    }, 
                                                    child: Text('확인', style: TextStyle(fontSize: 24, color: Colors.black)),
                                                  ),
                                                  ElevatedButton( 
                                                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(46, 61, 83, 1)),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text('취소', style: TextStyle(fontSize: 24, color: Colors.white)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));},
                          child: Text('주문'),)
              )]
              ),

              // ######## 메뉴 리스트 뷰 ########
              Obx(() => 
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  itemCount: controller.selectorderList.length,
                  itemBuilder: (context, index) {
                    final item = controller.selectorderList[index];
                    return Center(
                      child: Container(
                        width: 600,
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
                            // 이름과 가격
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('계약번호 : ${item.contractNum}\t\t\t'),
                                      Text('재료 이름 : ${item.ingredientName}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('주문 수량 : ${item.quantity}\t\t\t'),
                                      Text('주문 금액 : ${item.price}원')
                                    ],
                                  )
                                  ,
                                  Row(
                                    children: [
                                      Text('배송지 : ${item.factoryName}  =>  도착지 : ${item.companyCode}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('주문 일자 : ${item.contractDate.toString().substring(0,10)}\t\t\t'),
                                      item.deliveryDate == ''
                                      ? Text('아직 도착 하지않았습니다.')
                                      :Text('배달 일자 : ${item.deliveryDate!.substring(0,10)}')
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // 버튼들
                            item.deliveryDate == ''
                            ?Row(
                              children: [
                                // ######## 메뉴 수정 ########
                                ElevatedButton(
                                  onPressed: () async{
                                    await Get.defaultDialog(
                                      title: '배송 확인',
                                      titleStyle: TextStyle(fontSize: 30),
                                      titlePadding: EdgeInsets.fromLTRB(40, 40, 40, 20),
                                      content: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 98, 234, 83)),
                                                    onPressed: () {
                                                      controller.updateDelivery(item.contractNum!);
                                                      controller.selectorder();
                                                      Get.back();
                                                    }, 
                                                    child: Text('배송 확인', style: TextStyle(fontSize: 24, color: Colors.black)),
                                                  ),
                                                  ElevatedButton( 
                                                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(46, 61, 83, 1)),
                                                    onPressed: () {
                                                      controller.deleteDelivery(item.contractNum!);
                                                      controller.selectorder();
                                                      Get.back();
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
                                    backgroundColor: Color.fromARGB(255, 98, 234, 83),
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('배송 확인', style: TextStyle(fontSize: 20),),
                                ),
                                SizedBox(width: 8),

                                // ######## 메뉴 삭제 ########
                                ElevatedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: '선택한 주문를 삭제하시겠습니까?',
                                      titleStyle: TextStyle(fontSize: 30),
                                      titlePadding: EdgeInsets.all(40),
                                      content: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                }, 
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
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('주문 삭제', style: TextStyle(fontSize: 20),),
                                ),
                              ],
                            )
                          :
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('배달 완료', style: TextStyle(fontSize: 20),),
                                )
                            ],
                          )],
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