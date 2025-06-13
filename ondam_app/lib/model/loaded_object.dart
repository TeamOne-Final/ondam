// lib/model/loaded_object.dart
class LoadedObject {
  final int tableid; // 테이블 id
  final double xCoordinate; // 테이블 x 좌표
  final double yCoordinate; // 테이블 y 좌표
  final int tableNum; // 테이블 번호

  LoadedObject({
    required this.tableid,
    required this.xCoordinate,
    required this.yCoordinate,
    required this.tableNum,
  });

  // JSON 데이터로부터 LoadedObject 객체를 생성하는 팩토리 메서드
  factory LoadedObject.fromJson(Map<String, dynamic> json) {
    return LoadedObject(
      tableid: json['userTable_TableNum'] as int? ?? 0,
      xCoordinate: json['x'] as double? ?? 0.0, // num 타입을 double로 변환
      yCoordinate: json['y'] as double? ?? 0.0, // num 타입을 double로 변환
      tableNum: json['tableId'] as int? ?? 0,
    );
  }
}
