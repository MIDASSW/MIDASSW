import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'forgot_password_scrren.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              TextField(
                controller: _phonenumberController,
                decoration: InputDecoration(
                  hintText: '휴대폰 번호',
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
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  MyApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 222, 222),
                ),
                child: const Text('로그인',
                    style:
                        TextStyle(color: Color.fromARGB(255, 119, 118, 118))),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
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
                            builder: (context) => const RegisterScreen()),
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
              const Spacer(flex: 2),
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
              const Spacer(flex: 2),
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
              const Spacer(flex: 1),
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
              const Spacer(flex: 1),
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
              )
            ]),
      ),
    );
  }
}