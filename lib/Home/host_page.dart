import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Resources/jitsi_meet_methods.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  static String routeName = '/hostPage';

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  String _username = '';
  String _email = '';
  List _lessons = [];
  bool _isloadingSchedule = true;

  _getUserInfo() async {
    final pref = await SharedPreferences.getInstance();
    String path = '/member/get_member_detail';
    Map<String, dynamic> params = {
      'member_id': pref.getInt('id'),
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          _username = data['res']['username'];
          _email = data['res']['email'];
          _getLessons();
        }
      }
    });
  }

  _getLessons() async {
    final pref = await SharedPreferences.getInstance();
    String path = '/lesson/get_teacher_schedule';
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

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  _hostMeeting(int index) async {
    _jitsiMeetMethods.createNewMeeting(
      _lessons[index]['lessons_detail']['room_id'].toString(),
      isAudioMuted,
      isVideoMuted,
      _lessons[index]['subjects']['name'],
      _username,
      _email,
      lessonId: _lessons[index]['lessons_detail']['id'],
    );
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  _buildBack() {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, top: 60.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          CupertinoIcons.back,
          size: 64.0,
          color: Color(0xff595959),
        ),
      ),
    );
  }

  _buildTitle() {
    return const Center(
      child: Text(
        'Start Lesson',
        style: TextStyle(
          fontSize: 64.0,
          fontWeight: FontWeight.w600,
          height: 1,
          color: Color(0xff595959),
        ),
      ),
    );
  }

  Widget _buildMeetConfig() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Audio Muted",
              style: TextStyle(fontSize: 24.0),
            ),
            Switch.adaptive(
              value: isAudioMuted,
              onChanged: _onAudioMutedChanged,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Video Muted",
              style: TextStyle(fontSize: 24.0),
            ),
            Switch.adaptive(
              value: isVideoMuted,
              onChanged: _onVideoMutedChanged,
            ),
          ],
        ),
      ],
    );
  }

  _buildStartDateTime(index) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        _lessons[index]['lessons_detail']['start_datetime']);
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

  _buildLessons() {
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
                      onTap: (() => _hostMeeting(index)),
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
                                  _lessons[index]['lessons_detail']['id']
                                      .toString(),
                                  style: const TextStyle(fontSize: 24.0),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _lessons[index]['subjects']['name']
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              _buildBack(),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 116.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60.0),
                      _buildTitle(),
                      const SizedBox(height: 48.0),
                      _buildMeetConfig(),
                      const SizedBox(height: 48.0),
                      Expanded(
                        child: _buildLessons(),
                      ),
                      const SizedBox(height: 44.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
