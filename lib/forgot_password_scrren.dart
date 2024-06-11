import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Spacer(flex: 2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: '휴대폰 번호를 입력해주세요.',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 173, 174, 174),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 223, 222, 222),
              ),
              child: const Text('비밀번호 찾기',
                  style: TextStyle(color: Color.fromARGB(255, 119, 118, 118))),
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}