import 'package:get/get.dart';
import 'package:ondam_app/vm/chart_controller.dart';

class SideMenuController extends ChartController{
  final selectedIndex = 0.obs;

  void select(int index) {
    selectedIndex.value = index;
  }
}