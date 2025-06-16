import 'package:get/get.dart';
import 'package:ondam_app/vm/chart_controller.dart';

class SideMenuController extends ChartController{
  final selectedIndex = 0.obs; // 메인 사이드 바
  final selectedStoreReportProductIndex = 0.obs; // 
  final selectedMenuList = "".obs; // 메뉴 관리 드롭다운 버튼
  

  void select(int index) {
    selectedIndex.value = index;
  }

  void selectProductIdex(int index) {
    selectedStoreReportProductIndex.value = index;
  }

  void valueToMenuCode1(String value) {
    selectedMenuList.value = value;
    switch(selectedMenuList.value){
      case '메인메뉴':
        return fetchItemList('M');
      case '전체':
        return fetchItemList('%');
      case '사이드메뉴':
        return fetchItemList('S');
      case '음료':
        return fetchItemList('B');
      case '추가옵션':
        return fetchItemList('A');
    }
    // if(selectedMenuList.value == '메인메뉴'){
    //   return fetchItemList('M');
    // }
    // if(selectedMenuList.value == '전체'){
    //   return fetchItemList('%');
    // }
    // if(selectedMenuList.value == '사이드메뉴'){
    //   return fetchItemList('S');
    // }
    // if(selectedMenuList.value == '음료'){
    //   return fetchItemList('B');
    // }
    // if(selectedMenuList.value == '추가옵션'){
    //   return fetchItemList('A');
    // }
  }

}