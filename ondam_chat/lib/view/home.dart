import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/view/noticeview.dart';
import 'package:ondam_chat/view/tableview.dart';
import 'package:ondam_chat/vm/temp.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final tablecontroller =Get.find<Temp>();
  final tablename = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("테이블 선택"),
        actions: [
          IconButton(
            onPressed: () {
              showDg();
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Get.to(()=> Noticeview());
            }, 
            icon: Icon(Icons.notifications_none)
          )
        ],
      ),
      body: Obx(() => 
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // 한 줄에 2개씩
            crossAxisSpacing: 20,  // 가로 간격
            mainAxisSpacing: 20,  // 세로 간격
            childAspectRatio: 2,  // 가로세로 비율
          ),
          itemCount: tablecontroller.table.length,
          itemBuilder: (context, index) {
            final tableNo = tablecontroller.table[index];
            return Slidable(
              key: ValueKey(tableNo.tableId),
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      tablecontroller.deleteTable(tableNo.tableId);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '삭제',
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => Get.to(()=> Tableview(),arguments: [
                  tableNo.tableId,
                  tableNo.tableName,
                ]),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      tableNo.tableName,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  showDg() {
    Get.defaultDialog(
      title: "테이블 추가",
      content: Column(
        children: [
          TextField(
            controller: tablename,
            decoration: InputDecoration(
              labelText: "테이블 번호",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              tablecontroller.creatTable(tablename.text);
              tablename.clear();
              Get.back();
            },
            child: Text("추가하기"),
          ),
        ],
      ),
    );
  }
}//class