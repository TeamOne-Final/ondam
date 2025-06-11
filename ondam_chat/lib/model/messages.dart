import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String messageId; //ID(식별)
  final String sender; //보낸사람(왼쪽 오른쪽 구분하기위해)
  final String receiver;
  final String content; //메세지 내용
  final DateTime timestamp; //메세지 보낸 시간
  // final List<String> readBy; //읽음 안읽음 



  Messages({
    required this.messageId,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
    // required this.readBy
  });

  factory Messages.fromMap(Map<String, dynamic>map){//firebase에서 받는 데이터를 타입 변환 및 로직 생성
      return Messages(
        messageId: map["messageId"]??"",
        sender: map["sender"] ?? "",
        receiver: map["receiver"]??"",
        content: map["content"] ??"",
        timestamp: map["timestamp"] != null
            ? (map["timestamp"] as Timestamp).toDate()
            : DateTime.now(),
        // readBy: map["readBy"] is List
        // ? List<String>.from(map ["readBy"])
        // : [map["readBy"]as String],
      );
  }

    Map<String, dynamic> toMap(){
      return{
        "messageId":messageId,
        "sender": sender,
        "receiver" : receiver,
        "content" : content,
        "timestamp": Timestamp.fromDate(timestamp),
        // "readBy": readBy
        };
      }
}