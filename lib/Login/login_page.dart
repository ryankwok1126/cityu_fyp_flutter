import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:cityu_fyp_flutter/Login/forget_password_page.dart';
import 'package:cityu_fyp_flutter/Login/register_page.dart';
import 'package:cityu_fyp_flutter/Page/pageview_screen.dart';
import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String routeName = '/LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  bool _isLoading = false;
  bool _isObscureText = true;

  _showPassword() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  _forgetpassword() {
    Navigator.pushNamed(context, ForgetPasswordPage.routeName);
  }

  _login() {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
        _loginFormKey.currentState!.save();
      });
      String path = '/member/login';
      Map<String, dynamic> params = {
        'email': _emailController.text,
        'password': _pwController.text,
      };
      ApiManager.instance.post(path, params).then((response) async {
        if (mounted) {
          print(response);
          Map<String, dynamic> data = response;
          if (data['status'] == 1) {
            final pref = await SharedPreferences.getInstance();
            pref.setInt('id', data['res']['id']);
            pref.setString('role', data['res']['role']);
            pref.setString('language', data['res']['language']);
            if (mounted) {
              Navigator.pushReplacementNamed(context, PageViewScreen.routeName);
            }
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

  _register() {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  @override
  void initState() {
    _emailController.addListener(() {});
    _pwController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: MediaQuery.of(context).size.width / 3,
    );
  }

  _buildName() {
    return const Text(
      'CMOL',
      style: TextStyle(
        fontSize: 128.0,
        fontWeight: FontWeight.bold,
        color: MyColors.green,
      ),
    );
  }

  _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _buildEmail(),
          const SizedBox(height: 32.0),
          _buildPassword(),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerRight,
            child: _buildForgetPassword(),
          ),
          const SizedBox(height: 40.0),
          _buildLoginBtn(),
          const SizedBox(height: 40.0),
          _buildRegisterBtn(),
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
            obscureText: _isObscureText,
            decoration: InputDecoration(
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              suffixIcon: GestureDetector(
                onTap: () => _showPassword(),
                child: Image.asset(
                  (_isObscureText)
                      ? 'assets/images/pw_invisible.png'
                      : 'assets/images/pw_visible.png',
                  height: 32.0,
                  width: 32.0,
                  color: const Color(0xffa0a0a0),
                ),
              ),
              hintText: 'Password',
              hintStyle: const TextStyle(
                color: Color(0xffa0a0a0),
              ),
              border: InputBorder.none,
            ),
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

  _buildForgetPassword() {
    return GestureDetector(
      onTap: () => _forgetpassword(),
      child: const Text(
        'Forget Password?',
        style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xff7a7a7a)),
      ),
    );
  }

  _buildLoginBtn() {
    return GestureDetector(
      onTap: () => _login(),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: MyColors.green,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Center(
          child: (_isLoading)
              ? const SpinKitCircle(
                  color: Colors.white,
                  size: 48.0,
                )
              : const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  _buildRegisterBtn() {
    return GestureDetector(
      onTap: () => _register(),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xff757575),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: const Center(
          child: Text(
            'Register',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 116.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 140.0),
                  _buildLogo(),
                  const SizedBox(height: 20.0),
                  _buildName(),
                  const SizedBox(height: 64.0),
                  _buildLoginForm(),
                  const SizedBox(height: 64.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
