import 'package:flutter/material.dart';

class StoreProductAnalysis extends StatelessWidget {
  const StoreProductAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('상품 분석',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('총 판매 금액'),
                      Text('0원'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('총 판매 개수'),
                      Text('0건'),
                    ],
                  ),
                ],
              ),
            ),
                  Text('Best 상품'),
                  DataTable(
                    columnSpacing: 200,
                    columns: [
                    DataColumn(label: Text('순위')),
                            DataColumn(label: Text('상품')),
                            DataColumn(label: Text('판매 금액')),
                            DataColumn(label: Text('판매 개수')),
                    ], rows: [
                      DataRow(cells: [
                        DataCell(Text('1위')),
                        DataCell(Text('김상범')),
                        DataCell(Text('1원')),
                        DataCell(Text('1개')),
                      ])
                    ])
          ],
        ),
      ),
    );
  }
}