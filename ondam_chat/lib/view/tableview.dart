import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/view/chatroomview.dart';
import 'package:ondam_chat/view/messageview.dart';
import 'package:ondam_chat/vm/temp.dart';

class Tableview extends StatelessWidget {
  Tableview({super.key});
  final tablecontroller = Get.find<Temp>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var value = Get.arguments ?? "";
    final String tableId = value[0];
    final String mytableName = value[1];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: Text(
          mytableName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2A38),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1E2A38)),
            onPressed: () {
              Get.to(
                () => Chatroomview(),
                arguments: [tableId, tablecontroller.rId.value, mytableName],
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final filteredTables = tablecontroller.table
            .where((t) => t.tableName != mytableName)
            .toList();

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          children: List.generate(filteredTables.length, (index) {
            final tableNo = filteredTables[index];
            final scaleNotifier = ValueNotifier<double>(1.0);

            return ValueListenableBuilder<double>(
              valueListenable: scaleNotifier,
              builder: (context, scale, _) {
                return GestureDetector(
                  onTapDown: (_) => scaleNotifier.value = 0.97,
                  onTapUp: (_) => scaleNotifier.value = 1.0,
                  onTapCancel: () => scaleNotifier.value = 1.0,
                  onTap: () async {
                    await tablecontroller.creatRoom(
                      tableId,
                      mytableName,
                      tableNo.tableName,
                    );
                    Get.to(
                      () => Messageview(),
                      arguments: [
                        tableId,
                        mytableName,
                        tableNo.tableName,
                        tablecontroller.rId.value,
                      ],
                    );
                    _firestore.collection("chatroom")
                        .doc(tablecontroller.rId.value)
                        .update({"state": 0});
                  },
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFECEFF1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(4, 6),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(-4, -4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.table_bar, size: 40, color: Color(0xFF37474F)),
                          const SizedBox(height: 12),
                          Text(
                            tableNo.tableName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }
}