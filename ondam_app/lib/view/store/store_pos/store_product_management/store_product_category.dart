// 대리점 상품관리 카테고리 페이지
import 'package:flutter/material.dart';

class StoreProductCategory extends StatelessWidget {
  const StoreProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Text('카테고리',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ElevatedButton(onPressed: () {
                  
                }, child: Text('순서 편집')),
                ElevatedButton(onPressed: () {
                  
                }, child: Row(children: [Icon(Icons.add), Text('카테고리 추가')],)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
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