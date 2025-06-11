import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/model/messages.dart';
import 'package:ondam_chat/vm/chatcontroller.dart';

class Messagecontroller extends Chatcontroller{
  RxList<Messages> message = <Messages>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString messageId = "".obs;
  


  Future<void>messageView(String tableId, String roomId)async{
  final snapshot =  await _firestore.collection("chatroom")
                                      .doc(roomId)
                                      .collection("message")
                                      .orderBy("timestamp", descending: false)
                                      .get();
  message.value =
      snapshot.docs.map((doc) => Messages.fromMap(doc.data())).toList();
  }



  Future<void>sendMessage(String tableId ,String roomId,String content )async{
  final docRef = await _firestore.collection("chatroom")
                    .doc(roomId)
                    .collection("message")
                    .add({
                      "sender" : tableId,
                      "content" : content,
                      "timestamp" : FieldValue.serverTimestamp(),
                    });
    // 채팅방의 member 배열에서 '나'가 아닌 값을 가져와 상대방 식별
  final roomDoc = await _firestore.collection("chatroom").doc(roomId).get();

  if (roomDoc.exists) {
    final members = List<String>.from(roomDoc['member'] ?? []);
    final opponentName = members.firstWhere((name) => name != tableId);

    // '상대방이 보낸 메시지'일 때만 state = 1
    if (opponentName != tableId) {
      await _firestore
          .collection("chatroom")
          .doc(roomId)
          .update({"state": 1});
    }
  }
                    
    messageId.value = docRef.id ;
    messageView(tableId,roomId);
  }

  Future<void>deleteMessage(String roomId)async{
    await _firestore.collection("chatroom")
                    .doc(roomId)
                    .collection("message")
                    .doc()
                    .delete();
  }


  Future<void> deleteAllMessages(String roomId) async {
    final messageCollection = _firestore
        .collection("chatroom")
        .doc(roomId)
        .collection("message");

    const int batchSize = 500; // Firestore WriteBatch 최대 처리 단위
    bool hasMore = true;

    // 반복문으로 모든 메시지 삭제
    while (hasMore) {
      final querySnapshot = await messageCollection.limit(batchSize).get();

      // 더 이상 삭제할 문서가 없으면 반복 종료
      if (querySnapshot.size == 0) {
        hasMore = false;
        break;
      }

      // WriteBatch 생성 (동시에 여러 삭제 작업 수행)
      WriteBatch batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 현재 배치 커밋 (삭제 실행)
      await batch.commit();
    }
  }



  
}//class