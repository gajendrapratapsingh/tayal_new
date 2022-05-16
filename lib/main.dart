import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tayal/views/cart_screen.dart';
import 'package:tayal/views/category_screen.dart';
import 'package:tayal/views/change_address.dart';
import 'package:tayal/views/checkout_screen.dart';
import 'package:tayal/views/dashboard_screen.dart';
import 'package:tayal/views/ledger_calendar_screen.dart';
import 'package:tayal/views/mobile_login_screen.dart';
import 'package:tayal/views/order_detail_screen.dart';
import 'package:tayal/views/payment_options_screen.dart';
import 'package:tayal/views/product_detail_screen.dart';
import 'package:tayal/views/product_screen.dart';
import 'package:tayal/views/profile_screen.dart';
import 'package:tayal/views/selected_product_screen.dart';
import 'package:tayal/views/signup_screen.dart';
import 'package:tayal/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:tayal/views/subcategory_product_screen.dart';
import 'package:tayal/views/thanku_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tayal(Fintech)',
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: [
         GetPage(name: '/', page: () => MyApp()),
         GetPage(name: '/dashboard', page: () => DashBoardScreen(), transition: Transition.rightToLeft),
         GetPage(name: "/profile", page: () => ProfileScreen()),
         GetPage(name: '/category', page: () => CategoryScreen()),
         GetPage(name: '/subcategory', page: () => SubCategoryProductScreen()),
         GetPage(name: '/productdetail', page: () => ProductDetailScreen()),
         GetPage(name: '/cart', page: () => CartScreen()),
         GetPage(name: '/paymentoptions', page: () => PaymentOptionsScreen())
      ],
      theme: ThemeData(fontFamily: 'Poppins-Regular'),
         //home: ThankuScreen(),
        home: SplashScreen(),
    );
  }
}




