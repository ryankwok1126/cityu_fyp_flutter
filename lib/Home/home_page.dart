import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Home/host_page.dart';
import 'package:cityu_fyp_flutter/Home/join_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _role = '';
  List _lessonsDetail = [];
  List _lessonsSubject = [];
  bool _isloadingSchedule = true;

  _getRole() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _role = pref.getString('role') ?? '';
    });
    _getSchedule();
  }

  _getSchedule() async {
    _lessonsDetail = [];
    _lessonsSubject = [];
    final pref = await SharedPreferences.getInstance();
    String path = '';
    if (_role == 'T') {
      path = '/lesson/get_teacher_schedule';
    } else {
      path = '/lesson/get_student_schedule';
    }
    Map<String, dynamic> params = {
      'member_id': pref.getInt('id'),
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          setState(() {
            data['res'].forEach((lesson) => {
                  _lessonsDetail.add(lesson['lessons_detail']),
                  _lessonsSubject.add(lesson['subjects'])
                });
            _isloadingSchedule = false;
          });
        }
      }
    });
  }

  _host() {
    Navigator.pushNamed(context, HostPage.routeName);
  }

  _join() {
    Navigator.pushNamed(context, JoinPage.routeName);
  }

  @override
  void initState() {
    _getRole();
    super.initState();
  }

  _buildDate() {
    DateTime now = DateTime.now();
    String date = DateFormat('MMM d, yyyy(EEE)').format(now);
    return Text(
      date,
      style: const TextStyle(
        fontSize: 64.0,
        fontWeight: FontWeight.w600,
        color: Color(0xff595959),
      ),
    );
  }

  _buildHost() {
    return SizedBox(
      height: 316.0,
      child: ElevatedButton(
        onPressed: () {
          _host();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.lightGreen,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: const Center(
          child: Text(
            'Host',
            style: TextStyle(
              fontSize: 96.0,
              fontWeight: FontWeight.bold,
              color: MyColors.orange,
            ),
          ),
        ),
      ),
    );
  }

  _buildJoin(double fontSize) {
    return SizedBox(
      height: 316.0,
      child: ElevatedButton(
        onPressed: () {
          _join();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.lightGreen,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: const Center(
          child: Text(
            'Join',
            style: TextStyle(
              fontSize: 96.0,
              fontWeight: FontWeight.bold,
              color: MyColors.green,
            ),
          ),
        ),
      ),
    );
  }

  _buildStartDateTime(index) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        _lessonsDetail[index]['start_datetime']);
    String date = DateFormat('MMM d, yyyy').format(dateTime);
    String time = DateFormat('h:mm a').format(dateTime);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(text: '$date\n'),
          TextSpan(
              text: time, style: const TextStyle(color: Color(0xff5e5e5e))),
        ],
      ),
    );
  }

  _buildSchedule() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 100.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: MyColors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Start Time',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ID',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Subject',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: MyColors.darkGrey,
          ),
          if (_isloadingSchedule)
            const Padding(
              padding: EdgeInsets.all(100.0),
              child: SpinKitCircle(
                color: Color(0xff454545),
                size: 72.0,
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _lessonsDetail.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _lessonsDetail.length) {
                  return const SizedBox(height: 40.0);
                }
                return Column(
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildStartDateTime(index),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                _lessonsDetail[index]['id'].toString(),
                                style: const TextStyle(fontSize: 24.0),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _lessonsSubject[index]['name'].toString(),
                                style: const TextStyle(fontSize: 24.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: MyColors.darkGrey,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60.0),
              _buildDate(),
              const SizedBox(height: 22.0),
              // Teacher version
              if (_role == 'T')
                Row(
                  children: [
                    Expanded(child: _buildHost()),
                    const SizedBox(width: 28.0),
                    Expanded(child: _buildJoin(96.0)),
                  ],
                ),
              // Student version
              if (_role != 'T')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: _buildJoin(128.0),
                ),
              const SizedBox(height: 52.0),
              Expanded(
                child: _buildSchedule(),
              ),
              const SizedBox(height: 28.0),
            ],
          ),
        ),
      ),
    );
  }
}
