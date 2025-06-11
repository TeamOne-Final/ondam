import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/firebase_options.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_tab.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';
import 'package:ondam_app/view/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(VmHandlerTemp());
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Get.put(VmHandlerTemp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}
