import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/model/table.dart';

class Tablecontroller extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Table> table = <Table>[].obs;
  RxString tableId = "".obs;


@override
  void onInit() {
    super.onInit();
    loadTable();
  }

  Future<void> loadTable()async{
    final snapshot = await _firestore
                          .collection("table")
                          .orderBy("tableName")
                          .get();
  table.value = snapshot.docs.
    map( (doc) =>Table.fromDoc(doc),).toList();
  
  
  
}

Future<void> creatTable(String tableName)async{
  final docRef=  await _firestore.collection("table")
                    .add({
                      "tableName" : tableName,
                    });
  final table = docRef.id;
  tableId.value = table;

  loadTable();
}
Future<void>deleteTable(String tableId)async{
  await _firestore.collection("table")
                  .doc(tableId)
                  .delete();
  loadTable();
}


}//class