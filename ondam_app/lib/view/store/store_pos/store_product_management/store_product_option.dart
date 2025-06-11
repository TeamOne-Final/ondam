import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class StoreProductOption extends StatelessWidget {
  StoreProductOption({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
                  children: [
                    Text('옵션',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ElevatedButton(onPressed: () {
                      
                    }, child: Text('순서 편집')),
                    ElevatedButton(onPressed: () {
                      
                    }, child: Row(children: [Icon(Icons.add), Text('옵션 추가')],)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Text('$index'),
                            Switch(value: true, onChanged: (value) {
                            },)
                          ],
                        ),
                      );
                    },),
                )
        ],
      ),
    );
  }
}