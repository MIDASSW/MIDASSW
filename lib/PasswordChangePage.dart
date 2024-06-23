import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;
  bool _isPasswordVisible3 = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

void _showPasswordChangedDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Text('비밀번호가 변경되었습니다.', style: TextStyle(fontSize: 18)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인',style:TextStyle(color:Colors.black)),
          ),
        ],
      );
    },
  );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    hintText: '기존 비밀번호 입력',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible1 ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 173, 174, 174),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    } else if (value.length < 8) {
                      return '비밀번호는 8자리 이상입니다.';
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return '특수기호 1개 이상을 꼭 포함해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _newPasswordController,
                  inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    hintText: '새로운 비밀번호 입력',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2 ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 173, 174, 174),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    } else if (value.length < 8) {
                      return '비밀번호는 8자리 이상입니다.';
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return '특수기호 1개 이상을 꼭 포함해주세요.';
                    } else if (_oldPasswordController.text == value) {
                      return '기존 비밀번호와 같습니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    hintText: '새로운 비밀번호 다시 입력',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible3 ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 173, 174, 174),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible3 = !_isPasswordVisible3;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새로운 비밀번호를 다시 입력해주세요';
                    }
                    if (value != _newPasswordController.text) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showPasswordChangedDialog();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 196, 196, 196)),
                    fixedSize: MaterialStateProperty.all<Size>(const Size(160, 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
