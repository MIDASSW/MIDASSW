import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';
import 'ForgotPasswordPage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // 비밀번호 가시성 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRACKHOLE'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 화면 오버플로우 문제 해결
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40), // 상단 여백 추가
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
                        // highlight_off 버튼 누르면 다 지워짐
                        _phonenumberController.clear();
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(20),],
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // 비밀번호 가시성에 따라 아이콘 변경
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color.fromARGB(255, 173, 174, 174),
                      ),
                      onPressed: () {
                        // 비밀번호 가시성 상태 토글
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible, // 비밀번호 가시성 상태에 따라 업데이트
                ),
                const SizedBox(height: 20), // 버튼과 텍스트 필드 간격 추가
                ElevatedButton(
                  onPressed: () {
                  if (_phonenumberController.text.isEmpty) {
                    _showErrorDialog('휴대폰 번호를 입력해 주세요.');
                  } else if (!RegExp(r'^\d+$').hasMatch(_phonenumberController.text)) {
                    _showErrorDialog('휴대폰 번호는 숫자만 포함해야 합니다.');
                  } 
                  else if(_phonenumberController.text.length < 11)
                {
                   _showErrorDialog('휴대폰 번호를 정확하게 입력해 주세요.');
                }
                  else if(_passwordController.text.isEmpty)
                  {
                    _showErrorDialog('비밀번호를 입력해 주세요.');
                  }
                   else if(_passwordController.text.length<8)
                  {
                    _showErrorDialog('비밀번호는 8자리 이상입니다.');
                  }
                  else if(!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text))
                  {
                      _showErrorDialog('특수기호 1개 이상을 꼭 포함해주세요.');

                  }
                
                  else {
                    // 입력이 유효한 경우
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyApp()),
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
                const SizedBox(height: 20), // 버튼 간격 추가
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 119, 118, 118),
                      ),
                      child: const Text('비밀번호 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  RegisterPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 119, 118, 118), // 텍스트 색상 지정
                      ),
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // 간격 추가
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("또는"),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // 간격 추가
                // 카카오로 시작하기 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // 화면 가장자리와의 간격 조정
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.95, // 화면 너비의 95% 크기로 설정
                    height: MediaQuery.of(context).size.height *
                        0.05, // 화면 높이의 5% 크기로 설정
                    child: TextButton(
                      onPressed: () {
                        // 카카오 로그인 로직 구현
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.all(10), // 내부 여백
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
                              textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // 간격 추가
                // Apple로 시작하기 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // 여백을 주어 화면 가장자리와의 간격을 조정
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.95, // 화면 너비의 80% 크기로 설정
                    height: MediaQuery.of(context).size.height *
                        0.05, // 화면 높이의 5% 크기로 설정
                    child: TextButton(
                      onPressed: () {
                        // Apple 로그인 로직 구현
                      },
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
                              textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // 간격 추가
                // 구글로 시작하기 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // 여백을 주어 화면 가장자리와의 간격을 조정
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.95, // 화면 너비의 80% 크기로 설정
                    height: MediaQuery.of(context).size.height *
                        0.05, // 화면 높이의 5% 크기로 설정
                    child: TextButton(
                      onPressed: () {
                        // 구글 로그인 로직 구현
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 28, 183, 255),
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
                              textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // 하단 여백 추가
              ]),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('다시 입력하세요.'),
        content: Text(message),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
