import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovingObject {
  final Rx<Offset> position;

  final int id;

  static const double objectWidth = 60;
  static const double objectHeight = 60;

  MovingObject({required this.id, required Offset initialPosition})
    : position = initialPosition.obs;

  Rect getRect() {
    // 사각형으로 영역 주기
    final pos = position.value;
    return Rect.fromLTWH(pos.dx, pos.dy, objectWidth, objectHeight);
  }
}
