import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class StoreSalesStatus extends StatelessWidget {
  StoreSalesStatus({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('매출 현황',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: () {
                  
                }, child: Text('출력하기'))
              ],
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {
                  
                }, child: Text('어제')),
            ElevatedButton(onPressed: () {
              
            }, child: Text('오늘')),
            ElevatedButton(onPressed: () {
              
            }, child: Text('이번 주')),
            ElevatedButton(onPressed: () {
              
            }, child: Text('이번 달')),
              ],
            ),
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('실매출      '),
                      Text('주문건/ 건당 평균가')
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(onPressed: () {
                        vmHandler.selectedStoreReportProductIndex.value = 2;
                      }, label: Row(
                        children: [
                          Text('0원'),
                          Icon(Icons.arrow_right)
                        ],
                      )),
                      Text('0건'),
                      Text('0원'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('반품'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('반품금액 : 0원'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}