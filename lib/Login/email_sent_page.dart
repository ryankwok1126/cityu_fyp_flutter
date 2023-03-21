import 'dart:async';

import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Login/login_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailSentPage extends StatefulWidget {
  const EmailSentPage({super.key});

  static String routeName = '/emailSentPage';

  @override
  State<EmailSentPage> createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<EmailSentPage> {
  late String _email;
  String _content = '';
  late Timer _timer;
  int _second = 30;
  bool _canResend = false;

  _getParams() {
    final argments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    _email = argments['email'];
    setState(() {
      _content =
          'We\'ve sent an email to $_email with a link to get back into your account.';
    });
    _startTimer();
  }

  _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_second == 0) {
          setState(() {
            timer.cancel();
            _second = 30;
            _canResend = true;
          });
        } else {
          setState(() {
            _second--;
          });
        }
      },
    );
  }

  _resend() {
    setState(() {
      _canResend = false;
    });
    _startTimer();
    String path = '/member/forget_password';
    Map<String, dynamic> params = {
      'email': _email,
    };
    ApiManager.instance.post(path, params).then((response) async {
      if (mounted) {
        print(response);
        Map<String, dynamic> data = response;
        if (data['status'] == 1) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: Text(data['res']),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (data['status'] == 0) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: Text(data['err']),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: const Text('Error. Please try again.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    _getParams();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _buildTitle() {
    return const Center(
      child: Text(
        'Email Sent',
        style: TextStyle(
          fontSize: 64.0,
          fontWeight: FontWeight.w600,
          height: 1,
          color: Color(0xff595959),
        ),
      ),
    );
  }

  _buildContent() {
    return Text(
      _content,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w500,
        color: Color(0xff595959),
      ),
    );
  }

  _buildOkBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, LoginPage.routeName),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: MyColors.green,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: const Center(
          child: Text(
            'Ok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _buildResend() {
    return GestureDetector(
      onTap: () {
        if (_canResend) {
          _resend();
        }
      },
      child: Text(
        (_canResend) ? 'Resend' : 'Resend in ${_second}s',
        style: TextStyle(
          color: (_canResend)
              ? const Color(0xff127fff).withOpacity(0.9)
              : const Color(0xff595959),
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 116.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 72.0),
                _buildTitle(),
                const SizedBox(height: 120.0),
                _buildContent(),
                const SizedBox(height: 60.0),
                _buildOkBtn(),
                const SizedBox(height: 24.0),
                _buildResend(),
                const SizedBox(height: 64.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
