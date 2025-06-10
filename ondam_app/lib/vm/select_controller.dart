import 'package:get/get.dart';
import 'package:ondam_app/vm/purchase_controller.dart';

class SelectController extends PurchaseController {
  RxInt selectedIndexfordropdown = 0.obs;
  RxList<Map<String, dynamic>> shoppingList = <Map<String, dynamic>>[].obs;

  RxBool isEndDrawerOpen = false.obs;

  Rx<Map<String, dynamic>?> selectedDrawerItem = Rx<Map<String, dynamic>?>(
    null,
  );

  void selectdropdown(int index) {
    selectedIndexfordropdown.value = index;
    selectedDrawerItem.value = null;
  }

  void selectItemForDrawer(Map<String, dynamic> item) {
    selectedDrawerItem.value = item;
  }

  void clearSelectedDrawerItem() {
    selectedDrawerItem.value = null;
  }
}
