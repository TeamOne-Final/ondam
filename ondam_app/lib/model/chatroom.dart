class Chatroom {
  final String roomId;
  final List<String> member;
  final String roomname;
  final int state;


  Chatroom({
    required this.roomId,
    required this.member,
    required this.roomname,
    required this.state
  });

  factory Chatroom.fromMap(String id, Map<String, dynamic>map){
    return Chatroom(
      roomId: id,
      member: List<String>.from(map["member"]),
      roomname: map["roomname"]??"",
      state: map["state"]??0
    );
  }
  Map<String, dynamic>toMap(){
    return{
      "roomId" : roomId,
      "member" : member,
      "roomname" : roomname,
      "state" : state
    };
  }
}