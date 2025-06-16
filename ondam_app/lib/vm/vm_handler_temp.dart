import 'dart:async';

import 'package:get/get.dart';
import 'package:ondam_app/vm/order_controller.dart';

class VmHandlerTemp extends OrderController {
  //
  final dateTimeNow = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(seconds: 1), (timer) {dateTimeNow.value = DateTime.now();});
  }
}