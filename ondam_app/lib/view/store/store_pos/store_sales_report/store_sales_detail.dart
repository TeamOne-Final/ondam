import 'package:flutter/material.dart';

class StoreSalesDetail extends StatelessWidget {
  const StoreSalesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('매출 상세',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('매출'),
                      Text('0원')
                    ],
                  ),
                  Row(
                    children: [
                      Text('주문 건수'),
                      Text('0건')
                    ],
                  ),
                  Row(
                    children: [
                      Text('환불'),
                      Text('0월')
                    ],
                  ),
                  Row(
                    children: [
                      Text('환불 건수'),
                      Text('0건'),
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