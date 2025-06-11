import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String noticeId;
  final String title;
  final String content;
  final DateTime timeStamp;
  final int state;



  Notice({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.timeStamp,
    required this.state
  });


  factory Notice.fromMap(String id,Map <String , dynamic> map){
    return Notice(
      noticeId : id,
      title: map["title"],
      content: map["content"],
      timeStamp: map["timeStamp"] != null
            ? (map["timeStamp"] as Timestamp).toDate()
            : DateTime.now(),
      state : map["state"] ??0
    );
  }

  Map<String, dynamic>toMap(){
    return{
      "noticeId":noticeId,
      "title":title,
      "content":content,
      "timeStamp":timeStamp,
      "state" : state
    };
  }
}