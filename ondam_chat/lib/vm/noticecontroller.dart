import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/model/notice.dart';

class Noticecontroller extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList notice =[].obs;
  RxString nId = "".obs;

  Future<void> loadNotice()async{
  final snapshot =  await _firestore.collection("notice")
                                    .orderBy("state", descending: true)
                                    .get();
                    
    notice.value = snapshot.docs.map((doc) => 
        Notice.fromMap(doc.id ,doc.data()),).toList();
  }


  Future<void> createNotice(String title, String content, int state)async{
  final docId = await _firestore.collection("notice")
                    .add({
                      "title" : title,
                      "content" : content,
                      "timeStamp" : FieldValue.serverTimestamp(),
                      "state" : state
                    });
    nId.value = docId.id;               
    loadNotice();
  }

  Future<void> updateNotice(String noticeId, String title, String content, int state)async{
    await _firestore.collection("notice")
                    .doc(noticeId)
                    .set({
                      "title" : title,
                      "content" : content,
                      "timeStamp" : FieldValue.serverTimestamp(),
                      "state" : state
                    });
    loadNotice();

  }

  Future<void> deleteNotice(String noticeId)async{
    await _firestore.collection("notice")
                    .doc(noticeId)
                    .delete();
    loadNotice();
  }
}