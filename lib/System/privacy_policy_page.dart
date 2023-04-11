import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  static String routeName = '/PrivacyPolicyPage';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final _content =
      'This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. This is privacy policy. ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Color(0xff595959)),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            size: 32.0,
            color: Color(0xff595959),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    _content,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
