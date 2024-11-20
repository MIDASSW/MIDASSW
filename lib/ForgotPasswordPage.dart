import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(12),],
              decoration: const InputDecoration(
                hintText: '휴대폰 번호를 - 없이 입력해 주세요.',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 173, 174, 174),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                if (_phoneController.text.isEmpty) {
                  _showErrorDialog('휴대폰 번호를 입력해 주세요.');
                } else if (!RegExp(r'^\d+$').hasMatch(_phoneController.text)) {
                  _showErrorDialog('휴대폰 번호는 숫자만 포함해야 합니다.');
                }else if(_phoneController.text.length < 11)
                {
                   _showErrorDialog('휴대폰 번호를 정확하게 입력해 주세요.');
                }
                 else {
                  print('메시지 전송됨'); // 메시지 전송
                }
              },
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
