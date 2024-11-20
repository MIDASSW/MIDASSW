import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'HomePage.dart';
import 'ForgotPasswordPage.dart';
import 'RegisterPage.dart';
import 'package:provider/provider.dart';
import 'kakao_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CRACKHOLE',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                TextField(
                  controller: _phonenumberController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: InputDecoration(
                    hintText: '휴대폰 번호를 - 없이 입력해 주세요.',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.highlight_off,
                          color: Color.fromARGB(255, 173, 174, 174)),
                      onPressed: () {
                        _phonenumberController.clear();
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color.fromARGB(255, 173, 174, 174),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_phonenumberController.text.isEmpty) {
                      _showErrorDialog('휴대폰 번호를 입력해 주세요.');
                    } else if (!RegExp(r'^\d+$')
                        .hasMatch(_phonenumberController.text)) {
                      _showErrorDialog('휴대폰 번호는 숫자만 포함해야 합니다.');
                    } else if (_phonenumberController.text.length < 11) {
                      _showErrorDialog('휴대폰 번호를 정확하게 입력해 주세요.');
                    } else if (_passwordController.text.isEmpty) {
                      _showErrorDialog('비밀번호를 입력해 주세요.');
                    } else if (_passwordController.text.length < 8) {
                      _showErrorDialog('비밀번호는 8자리 이상입니다.');
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(_passwordController.text)) {
                      _showErrorDialog('특수기호 1개 이상을 꼭 포함해주세요.');
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 222, 222),
                  ),
                  child: const Text('로그인',
                      style:
                          TextStyle(color: Color.fromARGB(255, 119, 118, 118))),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 119, 118, 118),
                      ),
                      child: const Text('비밀번호 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 119, 118, 118),
                      ),
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                      onPressed: () async {
                        context.read<UserController>().kakaoLogin(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: AssetImage('assets/image/kakao.png'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '카카오로 시작하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: AssetImage('assets/image/apple.png'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Apple로 시작하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 28, 183, 255),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: AssetImage('assets/image/google.png'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '구글로 시작하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('다시 입력하세요.'),
        content: Text(message),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class UserController with ChangeNotifier {
  User? _user;
  final KakaoLoginApi kakaoLoginApi;
  User? get user => _user;

  UserController({required this.kakaoLoginApi});

  // 카카오 로그인
  void kakaoLogin(BuildContext context) async {
    {
      kakaoLoginApi.signWithKakao().then((user) {
        // 반환된 값이 NULL이 아니라면
        // 정보 전달
        if (user != null) {
          _user = user;
          notifyListeners();
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyApp()), // MyApp 페이지로 이동
        );
      });
    }
  }
}
