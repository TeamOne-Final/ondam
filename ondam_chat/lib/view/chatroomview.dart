import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/view/messageview.dart';
import 'package:ondam_chat/vm/temp.dart';

class Chatroomview extends StatelessWidget {
  Chatroomview({super.key});
  final chatroom = Get.find<Temp>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var value = Get.arguments ?? "__";
    final String tableId = value[0];
    final String mytableName = value[2];

    chatroom.loadchatroom(mytableName);
    String getOpponentName(chatroom, String mytableName) {
  return chatroom.member.firstWhere((name) => name != mytableName, orElse: () => "알 수 없음");
}

    return Scaffold(
      
      appBar: AppBar(title: Text("채팅방 목록")),
      body: Obx(
        () => ListView.builder(
          itemCount: chatroom.chatroom.length,
          itemBuilder: (context, index) {
            final chatroomView = chatroom.chatroom[index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Slidable(
                key: ValueKey(chatroomView.roomId),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        chatroom.deletechatroom(chatroomView.roomId);
                        chatroom.deleteAllMessages(chatroomView.roomId);
                        chatroom.loadchatroom(mytableName);
                        Get.snackbar(
                          "",
                          "채팅방이 삭제 되었습니다.",
                          backgroundColor: Colors.red.shade400,
                          colorText: Colors.white,
                        );
                      },
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      icon: Icons.exit_to_app,
                      label: '나가기',
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Messageview(),
                      arguments: [
                        tableId,
                        mytableName,
                        chatroomView.member[1],
                        chatroomView.roomId,
                      ],
                    );
                    _firestore
                        .collection("chatroom")
                        .doc(chatroomView.roomId)
                        .update({"state": 0});
                    chatroom.loadchatroom(mytableName);
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      height: 90,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.chat, size: 32),
                          SizedBox(width: 16),
                          Expanded(
                              child: Text(
                                getOpponentName(chatroomView, mytableName),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (chatroomView.state == 1)
                            Icon(Icons.circle, color: Colors.red, size: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}