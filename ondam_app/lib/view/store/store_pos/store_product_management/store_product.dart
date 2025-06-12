import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/side_menu_controller.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class StoreProduct extends StatelessWidget {
  StoreProduct({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();
  TextEditingController searchcontroller = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
            children: [
              Row(
                children: [
                  Text('상품',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 100,height: 50, child: TextField(controller: searchcontroller,decoration: InputDecoration(hintText: '메뉴검색', hintStyle: TextStyle(fontSize: 18)),)),
                  IconButton(onPressed: () {
                    
                  }, icon: Icon(Icons.search)),
                  ElevatedButton(onPressed: () {
                    vmHandler.purchaseSituationChart('강남');
                    print(vmHandler.purchaseSituationChartNowList); 
                  }, child: Text('순서 편집')),
                  ElevatedButton(onPressed: () {
                    
                  }, child: Row(children: [Icon(Icons.add), Text('상품 추가')],)),
                ],
              ),
              
              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 900,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed:() {
                            }, child: Text('$index')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('상품(총 ?개)'),
                  Text('재고수량'),
                  Text('품절 표시'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Icon(Icons.not_interested),
                          Text('data'),
                          Switch(value: true, onChanged: (value) {
                            
                          },)
                        ],
                      ),
                    );
                  },),
              )
            ],
          ),
      ),
    );
  }
}