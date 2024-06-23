import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  final RegExp _nameRegExp = RegExp(r'^[a-zA-Z가-힣]+$');
  final RegExp _emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final RegExp _phoneRegExp = RegExp(r'^\d+$');
  final RegExp _specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

 
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
  
    _nameController.addListener(() => _validateName(_nameController.text));
    _emailController.addListener(() => _validateEmail(_emailController.text));
    _phoneController.addListener(() => _validatePhone(_phoneController.text));
    _passwordController.addListener(() => _validatePassword(_passwordController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 
  void _validateName(String value) {
    setState(() {
      if (value.isEmpty || value.length == 1) {
        _nameError = '이름을 입력해 주세요.';
      } else if (!_nameRegExp.hasMatch(value)) {
        _nameError = '이름은 영어 또는 한글로 구성됩니다.';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = '이메일을 입력해 주세요.';
      } else if (!_emailRegExp.hasMatch(value)) {
        _emailError = '잘못된 이메일 형식입니다.';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = '휴대폰 번호를 입력해 주세요.';
      } else if (!_phoneRegExp.hasMatch(value)) {
        _phoneError = '휴대폰 번호는 숫자만 포함해야 합니다.';
      } else if (value.length < 11 || value.length > 12) {
        _phoneError = '휴대폰 번호를 정확하게 입력해 주세요.';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = '비밀번호를 입력해 주세요.';
      } else if (value.length < 8) {
        _passwordError = '비밀번호는 8자리 이상입니다.';
      } else if (!_specialCharRegExp.hasMatch(value)) {
        _passwordError = '특수기호 1개 이상을 꼭 포함해주세요.';
      } else {
        _passwordError = null;
      }
    });
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80),
                TextFormField(
                  controller: _nameController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(15),
                  ],
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
                        _nameController.clear();
                      },
                    ),
                  
                    errorText: _nameError,
                  ),
                
                  validator: (value) {
                    if (value!.isEmpty || value.length == 1) {
                      return '이름을 입력해 주세요.';
                    } else if (!_nameRegExp.hasMatch(value)) {
                      return '이름은 영어 또는 한글로 구성됩니다.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(25),
                  ],
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
                        _emailController.clear();
                      },
                    ),
            
                    errorText: _emailError,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '이메일을 입력해 주세요.';
                    } else if (!_emailRegExp.hasMatch(value)) {
                      return '잘못된 이메일 형식입니다.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: InputDecoration(
                    hintText: '휴대폰 번호를 -없이 입력해 주세요.',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    prefixIcon: const Icon(Icons.smartphone),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.highlight_off,
                          color: Color.fromARGB(255, 173, 174, 174)),
                      onPressed: () {
                        _phoneController.clear();
                      },
                    ),
           
                    errorText: _phoneError,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '휴대폰 번호를 입력해 주세요.';
                    } else if (!_phoneRegExp.hasMatch(value)) {
                      return '휴대폰 번호는 숫자만 포함해야 합니다.';
                    } else if (value.length < 11 || value.length > 12) {
                      return '휴대폰 번호를 정확하게 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    hintText: '비밀번호는 8자리 이상 특수기호 1개 이상을 꼭 포함해주세요.',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 173, 174, 174),
                    ),
                    prefixIcon: const Icon(Icons.lock),
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
        
                    errorText: _passwordError,
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '비밀번호를 입력해 주세요.';
                    } else if (value.length < 8) {
                      return '비밀번호는 8자리 이상입니다.';
                    } else if (!_specialCharRegExp.hasMatch(value)) {
                      return '특수기호 1개 이상을 꼭 포함해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print('회원가입 완료');
                    } else {
                      _showErrorDialog("입력한 정보를 확인해주세요.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 222, 222),
                  ),
                  child: const Text('가입하기',
                      style: TextStyle(
                          color: Color.fromARGB(255, 119, 118, 118))),
                ),
              ],
            ),
          ),
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
            child: const Text('확인'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
