import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Report/report_line_chart.dart';
import 'package:cityu_fyp_flutter/Report/report_pie_chart.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  static String routeName = '/reportPage';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late int _lessonId;
  late String _date;
  late String _time;
  List _studentId = [];
  final List<FlSpot> _overviewData = [];
  List<FlSpot> _studentData = [];
  int _countFocus = 0;
  int _countNotFocus = 0;
  int _countundefine = 0;
  late int _selectedSid;
  bool _isloadingSid = true;
  bool _isloadingOverview = true;
  bool _isloadingIndividual = true;

  _getParams() {
    final argments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    _lessonId = argments['lessonId'];
    _date = argments['date'];
    _time = argments['time'];
    _getStudent();
    _getReportOverview();
  }

  _getStudent() {
    String path = '/report/get_report_sid';
    Map<String, dynamic> params = {
      'lesson_id': _lessonId,
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          setState(() {
            _studentId = data['res'];
            _selectedSid = _studentId[0]['sid'];
            _isloadingSid = false;
          });
          _getStudentReport();
        }
      }
    });
  }

  _getStudentReport() {
    setState(() {
      _isloadingIndividual = true;
    });
    String path = '/report/get_student_report';
    Map<String, dynamic> params = {
      'lesson_id': _lessonId,
      'member_id': _selectedSid,
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          setState(() {
            _studentData = [];
            _countundefine = 0;
            _countNotFocus = 0;
            _countFocus = 0;
            List temp = data['res']['level'];
            for (var i = 0; i < temp.length; i++) {
              _studentData.add(FlSpot(i.toDouble(), temp[i].toDouble()));
              switch (temp[i]) {
                case 0:
                  _countundefine++;
                  break;
                case 1:
                  _countNotFocus++;
                  break;
                case 2:
                  _countFocus++;
                  break;
              }
            }
            _isloadingIndividual = false;
          });
        }
      }
    });
  }

  _getReportOverview() {
    String path = '/report/get_report_overview';
    Map<String, dynamic> params = {
      'lesson_id': _lessonId,
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          setState(() {
            List temp = data['res'];
            for (var i = 0; i < temp.length; i++) {
              _overviewData.add(FlSpot(i.toDouble(), temp[i].toDouble()));
            }
            _isloadingOverview = false;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    _getParams();
    super.didChangeDependencies();
  }

  _buildTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.back,
              size: 64.0,
              color: Color(0xff595959),
            ),
          ),
        ),
        Text(
          _date,
          style: const TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w600,
            color: Color(0xff595959),
          ),
        ),
        const Expanded(child: SizedBox()),
        Text(
          _time,
          style: const TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w600,
            color: Color(0xff595959),
          ),
        ),
      ],
    );
  }

  _buildOverview() {
    return Column(
      children: [
        const Text(
          'Concentration Overview',
          style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff595959)),
        ),
        Expanded(
          child: Row(
            children: [
              const RotatedBox(
                quarterTurns: 3,
                child: Text('levels',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff595959))),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ReportLineChart(
                      overviewData: _overviewData,
                      studentData: _studentData,
                    ),
                    if (_isloadingIndividual)
                      const Center(
                        child: SpinKitCircle(
                          color: Color(0xff454545),
                          size: 72.0,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        const Text('durations(min)',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff595959))),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20.0,
              width: 20.0,
              color: MyColors.lightGreen,
            ),
            const SizedBox(width: 10),
            const Text(
              'Average',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff595959)),
            ),
            if (!_isloadingIndividual) const SizedBox(width: 100),
            if (!_isloadingIndividual)
              Container(
                height: 20.0,
                width: 20.0,
                color: MyColors.darkGreen,
              ),
            if (!_isloadingIndividual) const SizedBox(width: 10),
            if (!_isloadingIndividual)
              Text(
                'S${_selectedSid.toString()}',
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff595959)),
              ),
          ],
        )
      ],
    );
  }

  _buildIndividual() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        color: MyColors.grey,
        child: Row(
          children: [
            SizedBox(
              width: 220.0,
              child: (!_isloadingSid)
                  ? ListView.builder(
                      itemCount: _studentId.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!_isloadingIndividual &&
                                    _selectedSid != _studentId[index]['sid']) {
                                  setState(() {
                                    _selectedSid = _studentId[index]['sid'];
                                    _getStudentReport();
                                  });
                                }
                              },
                              child: Container(
                                color:
                                    (_selectedSid == _studentId[index]['sid'])
                                        ? const Color(0xff2f2f2f)
                                        : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      top: 16.0,
                                      right: 12.0,
                                      bottom: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'S${_studentId[index]['sid']}',
                                        style: TextStyle(
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.w600,
                                            color: (_selectedSid ==
                                                    _studentId[index]['sid'])
                                                ? const Color(0xffcdcdcd)
                                                : const Color(0xff595959)),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      ClipOval(
                                        child: Container(
                                          height: 18.0,
                                          width: 18.0,
                                          color: (!_studentId[index]['focus'])
                                              ? const Color(0xffff2d2d)
                                              : const Color(0xff1dee1d),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 1.0,
                              color: Color(0xff2f2f2f),
                            ),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: SpinKitCircle(
                        color: Color(0xff454545),
                        size: 72.0,
                      ),
                    ),
            ),
            const VerticalDivider(
              width: 1.0,
              color: Color(0xff2f2f2f),
            ),
            if (_isloadingIndividual)
              const Expanded(
                child: SpinKitCircle(
                  color: Color(0xff454545),
                  size: 72.0,
                ),
              ),
            if (!_isloadingIndividual)
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    const Text('Individual Concentration report',
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff595959))),
                    Expanded(
                      child: ReportPieChart(
                        focus: _countFocus,
                        notFocus: _countNotFocus,
                        undefine: _countundefine,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                color: const Color(0xff67c587),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'focus',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff595959)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                color: const Color(0xffc9ead4),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'not focus',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff595959)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                color: const Color(0xffeaf6ed),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'undefine',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff595959)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
              const SizedBox(height: 54.0),
              if (_isloadingOverview)
                Expanded(
                  child: Column(
                    children: const [
                      Expanded(
                        child: SpinKitCircle(
                          color: Color(0xff454545),
                          size: 72.0,
                        ),
                      ),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              if (!_isloadingOverview)
                Expanded(
                  child: _buildOverview(),
                ),
              const SizedBox(height: 50.0),
              Expanded(
                child: _buildIndividual(),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
