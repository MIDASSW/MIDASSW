import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_screen.dart';
//import 'dart:async';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'login_screen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'dart:async';

// void main() async {

//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await dotenv.load(fileName: ".env");
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // 앱이 초기화되고 나면 스플래시 화면을 제거합니다.
//     Future.delayed(const Duration(seconds: 1), () async {
//       FlutterNativeSplash.remove();
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double logoWidth = screenWidth * 0.5; // 화면 너비의 50%
//     final double logoHeight = screenHeight * 0.3; // 화면 높이의 30%

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               width: logoWidth, // 동적으로 계산된 너비
//               height: logoHeight, // 동적으로 계산된 높이
//               color: Colors.white, // 배경색을 흰색으로 설정
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }