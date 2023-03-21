import 'package:cityu_fyp_flutter/Home/host_page.dart';
import 'package:cityu_fyp_flutter/Home/join_page.dart';
import 'package:cityu_fyp_flutter/Login/email_sent_page.dart';
import 'package:cityu_fyp_flutter/Login/forget_password_page.dart';
import 'package:cityu_fyp_flutter/Login/login_page.dart';
import 'package:cityu_fyp_flutter/Login/register_page.dart';
import 'package:cityu_fyp_flutter/Page/pageview_screen.dart';
import 'package:cityu_fyp_flutter/Report/report_page.dart';
import 'package:cityu_fyp_flutter/System/privacy_policy_page.dart';
import 'package:cityu_fyp_flutter/System/terms_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  LoginPage.routeName: (context) => const LoginPage(),
  RegisterPage.routeName: (context) => const RegisterPage(),
  ForgetPasswordPage.routeName: (context) => const ForgetPasswordPage(),
  EmailSentPage.routeName: (context) => const EmailSentPage(),
  PageViewScreen.routeName: (context) => const PageViewScreen(),
  ReportPage.routeName: (context) => const ReportPage(),
  HostPage.routeName: (context) => const HostPage(),
  JoinPage.routeName: (context) => const JoinPage(),
  TermsPage.routeName: (context) => const TermsPage(),
  PrivacyPolicyPage.routeName: (context) => const PrivacyPolicyPage(),
};
