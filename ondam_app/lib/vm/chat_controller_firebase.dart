import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ondam_app/model/chatroom.dart';

class Chatcontroller extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Chatroom> chatroom = <Chatroom>[].obs; 
  RxString rId= "".obs;

  Future<void>creatRoom(int mytable, String table)async{
  try{
    List<String> members = [mytable.toString(), table];
    members.sort(); //오름차순 정렬
    String roomId = members.join("과");//roomId == 'mytable_table'
    final docsnapshot = await _firestore.collection("chatroom")
                                        .doc(roomId)
                                        .get();
  if(docsnapshot.exists){//방이 있으면
    rId.value = roomId;
    Get.snackbar("", "기존 채팅방으로 이동합니다.");
  }else{//방이 없으면
    await _firestore.collection("chatroom")
                      .doc(roomId)
                      .set({
                        "member": members,
                        "roomname": "",
                        "state": 0 
                      });
    rId.value = roomId;
  }

  }catch(e){
    Get.snackbar("경고", "$e");
  }
}

  Future<void>updatechatroom(String roomId, String mytable, String table, int state)async{
    List<String> members = [mytable, table];
    members.sort(); //오름차순 정렬
    String roomId = members.join("과");//roomId == 'mytable_table'
    await _firestore.collection("chatroom")
                    .doc(roomId)
                    .set({
                      "member":members,
                      "roomname" : "$roomId번 테이블",
                      "state" : state
                      
                    });
  }

  Future<void>loadchatroom(String mytableNmae)async{
    final snapshot = await _firestore.collection("chatroom")
                                      .where("member", arrayContains: mytableNmae)
                                      .get();
chatroom.value = snapshot.docs
      .map((doc) => Chatroom.fromMap(doc.id, doc.data()))
      .toList();
  }

  Future<void>deletechatroom(String roomId)async{
    await _firestore.collection("chatroom")
                    .doc(roomId)
                    .delete();
  
  }


//   Future<void> hasNewMessage(String roomId, String myTableId) async {
//   // 나에게 온 메시지 중 가장 최근 하나를 조회
//   final snapshot = await _firestore
//       .collection("chatroom")
//       .doc(roomId)
//       .collection("message")
//       .where("receiver", isEqualTo: myTableId) // 내가 받은 메시지만 찾음
//       .orderBy("timestamp", descending: true)
//       .limit(1)
//       .get();

//    snapshot.docs.isNotEmpty; // 메시지가 있으면 NEW 표시 조건 만족
// }
//   /////////////채팅방 읽음 안읽음 처리////////////////////////////////////
///////////////////////////////////////////////////////////
  // Future<void>readChatroom(String tableId, String roomId)async{
  // final snapshot = await _firestore.collection("chatroom")
  //                                   .doc(roomId)
  //                                   .collection("message")
  //                                   .where("readBy", whereNotIn: [tableId])//읽지 않은 문서만 가져오기 
  //                                   .get();


  // WriteBatch batch = FirebaseFirestore.instance.batch();//덩어리로 묶어서 처리
  // for(var doc in snapshot.docs){
  //   batch.update(doc.reference, {
  //     "readBy" : FieldValue.arrayUnion([tableId])//중복없이 리스트에 넣는다 firebase 명령어
  //   });
  // }
  // await batch.commit();//batch실행


  // }
  

}//class