import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/image_controller.dart';

class TabModel extends ImageController with GetSingleTickerProviderStateMixin{
  late TabController tabController;

  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    },);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
  
}