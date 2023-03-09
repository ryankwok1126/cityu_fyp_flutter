import 'package:cityu_fyp_flutter/Home/meeting.dart';
import 'package:cityu_fyp_flutter/Page/pageview_screen.dart';
import 'package:cityu_fyp_flutter/Report/report_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  PageViewScreen.routeName: (context) => const PageViewScreen(),
  ReportPage.routeName: (context) => const ReportPage(),
  // Meeting.routeName: (context) => const Meeting()
};
