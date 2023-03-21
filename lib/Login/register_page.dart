import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/System/privacy_policy_page.dart';
import 'package:cityu_fyp_flutter/System/terms_page.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String routeName = '/RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  String _currentPw = '';
  bool _isLoading = false;

  _register() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
        _registerFormKey.currentState!.save();
      });
      final pref = await SharedPreferences.getInstance();
      String path = '/member/register';
      Map<String, dynamic> params = {
        'username': _nameController.text,
        'email': _emailController.text,
        'password': _pwController.text,
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
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                      Navigator.of(context).pop();
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
  void initState() {
    _nameController.addListener(() {});
    _pwController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
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

  _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: MediaQuery.of(context).size.width / 5,
    );
  }

  _buildName() {
    return const Text(
      'CMOL',
      style: TextStyle(
        fontSize: 96.0,
        fontWeight: FontWeight.bold,
        color: MyColors.green,
      ),
    );
  }

  _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          _buildUsername(),
          const SizedBox(height: 40.0),
          _buildEmail(),
          const SizedBox(height: 40.0),
          _buildPassword(),
          const SizedBox(height: 40.0),
          _buildConfirmPassword(),
          const SizedBox(height: 88.0),
          _buildTnc(),
          const SizedBox(height: 40.0),
          _buildRegisterBtn(),
        ],
      ),
    );
  }

  _buildUsername() {
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
            controller: _nameController,
            cursorColor: MyColors.green,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Full Name',
              hintStyle: TextStyle(
                color: Color(0xffa0a0a0),
              ),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == '') {
                return 'Username cannot be null or empty.';
              }
            },
          ),
        ),
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

  _buildPassword() {
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
            controller: _pwController,
            cursorColor: MyColors.green,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Color(0xffa0a0a0),
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              _currentPw = value;
            },
            validator: (value) {
              if (value == '') {
                return 'Password cannot be null or empty.';
              }
            },
          ),
        ),
      ),
    );
  }

  _buildConfirmPassword() {
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
            controller: _confirmPwController,
            cursorColor: MyColors.green,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                color: Color(0xffa0a0a0),
              ),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == '') {
                return 'Confirm password cannot be null or empty.';
              }
              if (value != _currentPw) {
                return 'Passwords do not match.';
              }
            },
          ),
        ),
      ),
    );
  }

  _buildTnc() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        const Text(
          'By signing up, you agree to our ',
          style: TextStyle(
            color: Color(0xff757575),
            fontSize: 20.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, TermsPage.routeName);
          },
          child: Text(
            'Terms',
            style: TextStyle(
              color: const Color(0xff127fff).withOpacity(0.9),
              fontSize: 20.0,
            ),
          ),
        ),
        const Text(
          ' & ',
          style: TextStyle(
            color: Color(0xff757575),
            fontSize: 20.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
          },
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              color: const Color(0xff127fff).withOpacity(0.9),
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  _buildRegisterBtn() {
    return GestureDetector(
      onTap: () => _register(),
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
                  'Register',
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
                    const SizedBox(height: 108.0),
                    _buildLogo(),
                    const SizedBox(height: 20.0),
                    _buildName(),
                    const SizedBox(height: 64.0),
                    _buildRegisterForm(),
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
