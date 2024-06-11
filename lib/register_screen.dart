import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // 비밀번호 가시성 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력해주세요.',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.highlight_off,
                        color: Color.fromARGB(255, 173, 174, 174)),
                    onPressed: () {
                      // highlight_off 버튼 누르면 다 지워짐
                      _nameController.clear();
                    },
                  ),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '이메일을 입력해주세요.',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.highlight_off,
                        color: Color.fromARGB(255, 173, 174, 174)),
                    onPressed: () {
                      // highlight_off 버튼 누르면 다 지워짐
                      _emailController.clear();
                    },
                  ),
                ),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '휴대폰 번호를 입력해주세요.',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  prefixIcon: const Icon(Icons.smartphone),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.highlight_off,
                        color: Color.fromARGB(255, 173, 174, 174)),
                    onPressed: () {
                      // highlight_off 버튼 누르면 다 지워짐
                      _phoneController.clear();
                    },
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호를 입력해주세요.',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  hintText: '8~11글자에 특수 기호를 포함해야 합니다.',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  prefixIcon: const Icon(Icons.lock),
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
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 로직 구현
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 222, 222),
                ),
                child: const Text('가입하기',
                    style:
                        TextStyle(color: Color.fromARGB(255, 119, 118, 118))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}