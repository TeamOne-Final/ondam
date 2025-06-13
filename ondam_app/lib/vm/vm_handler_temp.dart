import 'dart:async';

import 'package:get/get.dart';
import 'package:ondam_app/vm/tab_model.dart';

class VmHandlerTemp extends TabModel {
  //
  final dateTimeNow = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(seconds: 1), (timer) {dateTimeNow.value = DateTime.now();});
  }
}