import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:ondam_app/firebase_options.dart'
import 'package:ondam_app/view/login.dart';
import 'package:ondam_app/view/home.dart';
import 'package:ondam_app/view/store/pos_orderhistory.dart';
import 'package:ondam_app/view/store/store_main.dart';
import 'package:ondam_app/view/store/store_pos/store_product_management/store_product_tab.dart';

import 'package:ondam_app/vm/notice_controller_firebase.dart';
import 'package:ondam_app/vm/vm2handelr.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(VmHandlerTemp());
  Get.put(Noticecontroller());
  Get.put(Vm2handelr());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      locale: Locale('ko', 'KR'),
      supportedLocales: [Locale('ko', 'KR')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: Posorderhistory()
      // home: Home(),
      home: Login(),


    );
  }
}
