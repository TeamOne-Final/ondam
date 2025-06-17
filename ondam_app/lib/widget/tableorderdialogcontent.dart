// lib/view/table_order_dialog_content.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/vm/vm2handelr.dart';

class TableOrderDialogContent extends StatelessWidget {
  final Vm2handelr vmHandler;
  final String tableNum; // 필요하다면 tableNum도 전달받을 수 있습니다.

  const TableOrderDialogContent({
    super.key,
    required this.vmHandler,
    required this.tableNum, // tableNum을 받도록 추가
  });

  @override
  Widget build(BuildContext context) {
    // 다이얼로그 내용의 최대 높이 제한을 위해 Container 사용
    return SizedBox(
      width: double.maxFinite, // 너비 최대로
      height: 300,
      child: Obx(() {
        // 주문 목록 변경 시 UI 업데이트를 위해 Obx로 감쌈
        if (vmHandler.isTableOrderLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // VmHandlerTemp에서 해당 테이블의 주문 항목 목록을 가져옵니다.
        final orderItems = vmHandler.tableOrderItems;
        if (orderItems.isEmpty) {
          return Center(child: Text('현재 주문 내역이 없습니다.'));
        } else {
          // 총 금액 계산 (VmHandlerTemp에서 계산하거나 여기서 계산)
          double totalAmount = 0.0;
          for (var item in orderItems) {
            totalAmount +=
                (item['price_at_order'] as num? ?? 0.0) *
                (item['quantity'] as int? ?? 0);
          }

          return ListView(
            // 주문 항목이 많을 경우 스크롤 가능하도록 ListView 사용
            shrinkWrap: true, // 내용 크기에 맞게 ListView 크기 조절
            children: [
              // 각 주문 항목 표시
              ...orderItems.map((item) {
                return ListTile(
                  title: Text('${item['menuName']}'), // product 테이블에서 가져온 메뉴 이름
                  subtitle: Text(
                    '${(item['price_at_order'] as num? ?? 0.0).toStringAsFixed(0)} 원 x ${item['quantity']}',
                  ), // 단가 x 수량
                  trailing: Text(
                    '${((item['price_at_order'] as num? ?? 0.0) * (item['quantity'] as int? ?? 0)).toStringAsFixed(0)} 원',
                  ), // 항목별 총 가격
                );
              }),
              Divider(),
              // 총 금액 표시 (Obx 내부에 있으므로 orderItems 변경 시 함께 업데이트)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  '총 금액: ${totalAmount.toStringAsFixed(0)} 원',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
