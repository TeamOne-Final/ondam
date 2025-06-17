import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ondam_app/colors.dart';
import 'package:ondam_app/view/chatting/messageview.dart';
import 'package:ondam_app/vm/chat_controller_firebase.dart';
import 'package:ondam_app/vm/message_controller_firebase.dart';

class Chatroomview extends StatelessWidget {
  Chatroomview({super.key});
  final chatroom = Get.find<Chatcontroller>();
  final message = Get.find<Messagecontroller>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var value = Get.arguments ?? "__";
    final String mytableName = value[0];

    chatroom.loadchatroom(mytableName.toString());

    String getOpponentName(chatroom, String mytableName) {
      return chatroom.member.firstWhere(
        (name) => name != mytableName,
        orElse: () => "알 수 없음",
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 254, 255),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("채팅방 목록", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: chatroom.chatroom.length,
          itemBuilder: (context, index) {
            final chatroomView = chatroom.chatroom[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Slidable(
                key: ValueKey(chatroomView.roomId),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        chatroom.deletechatroom(chatroomView.roomId);
                        message.deleteAllMessages(chatroomView.roomId);
                        chatroom.loadchatroom(mytableName.toString());
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
                        mytableName,
                        chatroomView.member[1],
                        chatroomView.roomId,
                      ],
                    );
                    _firestore
                        .collection("chatroom")
                        .doc(chatroomView.roomId)
                        .update({"state": 0});
                    chatroom.loadchatroom(mytableName.toString());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.indigoAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${getOpponentName(chatroomView, mytableName)}번 테이블",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                            ],
                          ),
                        ),
                        if (chatroomView.state == 1)
                          Icon(Icons.circle, color: Colors.red, size: 12),
                      ],
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
