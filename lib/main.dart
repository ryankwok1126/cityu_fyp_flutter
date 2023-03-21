import 'dart:io';

import 'package:cityu_fyp_flutter/Login/login_page.dart';
import 'package:cityu_fyp_flutter/Page/pageview_screen.dart';
import 'package:cityu_fyp_flutter/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Need to solve certificate issue while release to prodction
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // Need to solve certificate issue while release to prodction
  HttpOverrides.global = MyHttpOverrides();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final pref = await SharedPreferences.getInstance();
  runApp(MyApp(id: pref.getInt('id') ?? -1));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/logo.png"), context)
        .then((value) => FlutterNativeSplash.remove());
    return MaterialApp(
      title: 'CMOL',
      debugShowCheckedModeBanner: false,
      initialRoute: (id == -1) ? LoginPage.routeName : PageViewScreen.routeName,
      routes: routes,
    );
  }
}
