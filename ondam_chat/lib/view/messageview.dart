import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_chat/vm/temp.dart';

class Messageview extends StatelessWidget {
  Messageview({super.key});
  final chatroom = Get.find<Temp>();
  final sendMessageController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    var value = Get.arguments ?? "__";
    final String tableId = value[0];
    // final String mytable = value[1];
    final String table = value[2];
    // final String roomId = value[3];
    chatroom.messageView(tableId, value[3]);

    return Scaffold(
      appBar: AppBar(title: Text("$table ")),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatroom.message.length,
                itemBuilder: (context, index) {
                  final message = chatroom.message[index];
                  return Align(
                    alignment:
                        message.sender == tableId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color:
                                message.sender == tableId
                                    ? Colors.blue[100]
                                    : const Color.fromARGB(255, 152, 156, 152),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(message.content, style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sendMessageController,
                      decoration: InputDecoration(
                        labelText: "메세지를 입력 하세요.",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.go,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      chatroom.sendMessage(
                        tableId,
                        value[3].toString(),
                        sendMessageController.text,
                      );
                      sendMessageController.clear();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
