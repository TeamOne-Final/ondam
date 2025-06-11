import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  final String tableName;
  final String tableId;
  
  

  Table({
    required this.tableName,
    required this.tableId,
  });

  factory Table.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Table(
      tableName: map["tableName"] ?? '',
      tableId: doc.id,  
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'tableName': tableName,
      'tableId': tableId,
    };
  }

}
  