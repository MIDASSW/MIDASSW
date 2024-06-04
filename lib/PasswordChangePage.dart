import 'package:flutter/material.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '비밀번호 변경',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '기존 비밀번호 입력',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '새로운 비밀번호 입력',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _confirmNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '새로운 비밀번호 다시 입력',
              ),
            ),
            SizedBox(height: 40),
               ElevatedButton(
                    onPressed: () {
                      //사진을 찍었을때 이미지를 저장할수 있도록 한다.
                    },
                    style: ButtonStyle(
                      backgroundColor:  MaterialStateProperty.all<Color>(const Color.fromARGB(255, 196, 196, 196)),
                      fixedSize: MaterialStateProperty.all<Size>(const Size(160,20)),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),
                        )
                      )
                      ),
                       child: const Text('확인',style: TextStyle(color: Colors.white )
                       ),
                    ),

          ],
        ),
      ),
    );
  }
}
