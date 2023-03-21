import 'package:cityu_fyp_flutter/Home/home_page.dart';
import 'package:cityu_fyp_flutter/Report/report_list_page.dart';
import 'package:cityu_fyp_flutter/Setting/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  static String routeName = '/pageviewScreen';

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  String _role = '';
  int _selectedIndex = 0;
  final _controller = PageController(initialPage: 0);

  _getRole() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _role = pref.getString('role') ?? '';
    });
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _controller.animateToPage(value,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    _getRole();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          if (_role == 'T')
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart_fill),
              label: 'Report',
            ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_solid),
            label: 'Setting',
          )
        ],
        onTap: _onTappedBar,
        selectedItemColor: const Color(0xff004c00),
        unselectedItemColor: const Color(0xffd3d3d3),
        currentIndex: _selectedIndex,
      ),
      body: PageView(
        controller: _controller,
        children: [
          const HomePage(),
          if (_role == 'T') const ReportListPage(),
          const SettingPage(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }
}
