import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Login/email_sent_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  static String routeName = '/ForgetPasswordPage';

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _content =
      'Enter your email address,\nand we\'ll send you a link to get back\ninto your account.';

  _sendLink() {
    if (_emailFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
        _emailFormKey.currentState!.save();
      });
      String path = '/member/forget_password';
      Map<String, dynamic> params = {
        'email': _emailController.text,
      };
      ApiManager.instance.post(path, params).then((response) async {
        if (mounted) {
          print(response);
          Map<String, dynamic> data = response;
          if (data['status'] == 1) {
            Navigator.pushNamedAndRemoveUntil(context, EmailSentPage.routeName,
                (Route<dynamic> route) => false,
                arguments: {'email': _emailController.text});
          } else if (data['status'] == 0) {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                content: Text(data['err']),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Ok'),
                    onPressed: () {
                      setState(() {
                        _isLoading = !_isLoading;
                      });
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
                      setState(() {
                        _isLoading = !_isLoading;
                      });
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  _buildBack() {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, top: 72.0),
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
        'Forget Password',
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

  _buildEmailForm() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          _buildEmail(),
          const SizedBox(height: 40.0),
          _buildSendLinkBtn(),
        ],
      ),
    );
  }

  _buildEmail() {
    return Container(
      height: 80.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        color: MyColors.grey,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: TextFormField(
            controller: _emailController,
            cursorColor: MyColors.green,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(
                color: Color(0xffa0a0a0),
              ),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == '') {
                return 'Email cannot be null or empty.';
              }
              if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!)) {
                return 'Invalid email format.';
              }
            },
          ),
        ),
      ),
    );
  }

  _buildSendLinkBtn() {
    return GestureDetector(
      onTap: () => _sendLink(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80.0,
        width: (_isLoading) ? 80.0 : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyColors.green,
          borderRadius: (_isLoading)
              ? const BorderRadius.all(Radius.circular(80.0))
              : const BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Center(
          child: (_isLoading)
              ? const SpinKitCircle(
                  color: Colors.white,
                  size: 48.0,
                )
              : const Text(
                  'Send Link',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              _buildBack(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 116.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 72.0),
                    _buildTitle(),
                    const SizedBox(height: 120.0),
                    _buildContent(),
                    const SizedBox(height: 60.0),
                    _buildEmailForm(),
                    const SizedBox(height: 64.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
