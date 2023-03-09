import 'dart:io';

import 'package:cityu_fyp_flutter/Page/pageview_screen.dart';
import 'package:cityu_fyp_flutter/routes.dart';
import 'package:flutter/material.dart';

// Need to solve certificate issue while release to prodction
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // Need to solve certificate issue while release to prodction
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMOL',
      debugShowCheckedModeBanner: false,
      initialRoute: PageViewScreen.routeName,
      routes: routes,
    );
  }
}
