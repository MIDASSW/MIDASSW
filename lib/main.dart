import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'kakao_login.dart';
import 'LoginPage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(
    nativeAppKey: '3ZLW/TAqPvR43Zh79ejFQDOdka8=',
    javaScriptAppKey: '3de278e4a1cd2102015c02704b9fecb9',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserController(kakaoLoginApi: KakaoLoginApi())),
        ChangeNotifierProvider(create: (_) => GoogleSignInController()),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
