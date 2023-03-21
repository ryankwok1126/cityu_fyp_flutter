import 'package:cityu_fyp_flutter/Login/login_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  _logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('id');
    pref.remove('role');
    pref.remove('language');
    if (mounted) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }

  _buildTitle() {
    return const Text(
      'Setting',
      style: TextStyle(
        fontSize: 64.0,
        fontWeight: FontWeight.w600,
        color: Color(0xff595959),
      ),
    );
  }

  _buildAccountSetting() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: GestureDetector(
        onTap: () => print('hi'),
        child: Container(
          height: 100.0,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 20.0),
            child: Row(
              children: const [
                Text(
                  'Account',
                  style: TextStyle(fontSize: 36.0),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xff595959),
                  size: 36.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildLessonSetting() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print('Audio'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Audio',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: MyColors.darkGrey,
          ),
          GestureDetector(
            onTap: () => print('Video'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Video',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildGeneralSetting() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print('Privacy'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Privacy',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: MyColors.darkGrey,
          ),
          GestureDetector(
            onTap: () => print('Language'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Language',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: MyColors.darkGrey,
          ),
          GestureDetector(
            onTap: () => print('Notification'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Notification',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: MyColors.darkGrey,
          ),
          GestureDetector(
            onTap: () => print('Contact Us'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: MyColors.darkGrey,
          ),
          GestureDetector(
            onTap: () => print('About'),
            child: Container(
              height: 100.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 20.0),
                child: Row(
                  children: const [
                    Text(
                      'About',
                      style: TextStyle(fontSize: 36.0),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xff595959),
                      size: 36.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLogout() {
    return GestureDetector(
      onTap: () => _logout(),
      child: Container(
        height: 100.0,
        decoration: const BoxDecoration(
            color: MyColors.logout,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: const Center(
          child: Text(
            'Logout',
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ),
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: ListView(
            children: [
              const SizedBox(height: 60.0),
              _buildTitle(),
              const SizedBox(height: 28.0),
              _buildAccountSetting(),
              const SizedBox(height: 36.0),
              _buildLessonSetting(),
              const SizedBox(height: 36.0),
              _buildGeneralSetting(),
              const SizedBox(height: 36.0),
              _buildLogout(),
              const SizedBox(height: 36.0),
            ],
          ),
        ),
      ),
    );
  }
}
