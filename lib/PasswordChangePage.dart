import 'package:flutter/material.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

   bool _isPasswordVisible1 = false;
   bool _isPasswordVisible2= false;
   bool _isPasswordVisible3 = false;

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
                decoration: InputDecoration(
                  hintText: '기존 비밀번호 입력',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // 비밀번호 가시성에 따라 아이콘 변경
                      _isPasswordVisible1
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color.fromARGB(255, 173, 174, 174),
                    ),
                    onPressed: () {
                      // 비밀번호 가시성 상태 토글
                      setState(() {
                        _isPasswordVisible1 = !_isPasswordVisible1;
                      });
                    },
                  ),
                ),
              ),
            SizedBox(height: 30),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: '새로운 비밀번호 입력',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // 비밀번호 가시성에 따라 아이콘 변경
                      _isPasswordVisible2
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color.fromARGB(255, 173, 174, 174),
                    ),
                    onPressed: () {
                      // 비밀번호 가시성 상태 토글
                      setState(() {
                        _isPasswordVisible2 = !_isPasswordVisible2;
                      });
                    },
                  ),
                ),
              ),
            SizedBox(height: 30),
                          TextField(
                controller: _confirmNewPasswordController,
                decoration: InputDecoration(
                  hintText: '새로운 비밀번호 다시 입력',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 174, 174),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // 비밀번호 가시성에 따라 아이콘 변경
                      _isPasswordVisible3
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color.fromARGB(255, 173, 174, 174),
                    ),
                    onPressed: () {
                      // 비밀번호 가시성 상태 토글
                      setState(() {
                        _isPasswordVisible3 = !_isPasswordVisible3;
                      });
                    },
                  ),
                ),
              ),
            SizedBox(height: 40),
               ElevatedButton(
                    onPressed: () {
                    
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
