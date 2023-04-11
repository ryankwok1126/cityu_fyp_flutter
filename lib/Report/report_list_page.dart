import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Report/report_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List _lessons = [];
  bool _isloadingSchedule = true;

  _getReportList() async {
    final pref = await SharedPreferences.getInstance();
    String path = '/report/get_report_list';
    Map<String, dynamic> params = {
      'member_id': pref.getInt('id'),
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          setState(() {
            _lessons = data['res'];
            _isloadingSchedule = false;
          });
        }
      }
    });
  }

  _goToReport(int index) {
    int id = _lessons[index]['lesson_detail'][0]['id'];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        _lessons[index]['lesson_detail'][0]['start_datetime']);
    String date = DateFormat('MMM d, yyyy').format(dateTime);
    String time = DateFormat('h:mm a').format(dateTime);
    Navigator.pushNamed(context, ReportPage.routeName,
        arguments: {'lessonId': id, 'date': date, 'time': time});
  }

  @override
  void initState() {
    _getReportList();
    super.initState();
  }

  _buildTitle() {
    return const Text(
      'Report List',
      style: TextStyle(
        fontSize: 64.0,
        fontWeight: FontWeight.w600,
        color: Color(0xff595959),
      ),
    );
  }

  _buildStartDateTime(index) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        _lessons[index]['lesson_detail'][0]['start_datetime']);
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
                  SizedBox(width: 24.0),
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
              itemCount: _lessons.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _lessons.length) {
                  return const SizedBox(height: 40.0);
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: (() => _goToReport(index)),
                      child: Container(
                        height: 100.0,
                        color: Colors.transparent,
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
                                  _lessons[index]['lesson_detail'][0]['id']
                                      .toString(),
                                  style: const TextStyle(fontSize: 24.0),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _lessons[index]['subject'][0]['name']
                                      .toString(),
                                  style: const TextStyle(fontSize: 24.0),
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.right_chevron,
                                size: 24.0,
                                color: Color(0xff636363),
                              ),
                            ],
                          ),
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
              _buildTitle(),
              const SizedBox(height: 28.0),
              Expanded(
                child: _buildSchedule(),
              ),
              const SizedBox(height: 44.0),
            ],
          ),
        ),
      ),
    );
  }
}
