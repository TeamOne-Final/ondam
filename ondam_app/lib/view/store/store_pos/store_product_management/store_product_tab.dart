import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_category.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_option.dart';
import 'package:ondam_app/vm/side_menu_controller.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class StoreProductTab extends StatelessWidget {
  StoreProductTab({super.key});
  final vmHandler = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(color: const Color.fromRGBO(46, 61, 83, 1)),
            child: 
                ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('상품관리', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),)]
                      ),
                    _buildTile(vmHandler, 0, Icons.store, '상품'),
                    _buildTile(vmHandler, 1, Icons.restaurant, '옵션'),
                    _buildTile(vmHandler, 2, Icons.approval, '카테고리'),
                  ],
                ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Obx(() {
            switch (vmHandler.selectedStoreProductIndex.value){
              case 0:
                return StoreProduct();
              case 1:
                return StoreProductOption();
              case 2:
                return StoreProductCategory();
              default:
                return Center(child: Text('페이지를 선택해 주세요'),);
            }
          },),
        )
      ],
    ) 
    );
    
  }

  Widget _buildTile(SideMenuController vmHandler, int index, IconData icon, String title){
    return Obx(() {
      final isSelected = vmHandler.selectedStoreProductIndex.value == index;

      return Container(
        color: isSelected ? Color(0xFFF6F7FB) : Colors.transparent,
        child: ListTile(
          onTap: () {
            vmHandler.selectProductIdex(index);
          },
          leading: Icon(icon, color: isSelected ? Colors.black : Colors.white,size: 32),
          title: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
      );
    },);
}}