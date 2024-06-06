import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  double lat = 0;
  double lng = 0;
  Location location = new Location();
  bool _serviceEnabled = true;
  late PermissionStatus _permissionGranted;

  // 사용자의 위치를 찾는 함수
  _locateMe() async {
    // 위치 서비스가 활성화되어 있는지 확인
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      // 활성화되지 않은 경우 위치 서비스 요청
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return; // 여전히 활성화되지 않은 경우 종료
      }
    }

    // 위치 권한이 허용되었는지 확인
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // 권한이 거부된 경우 위치 권한 요청
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // 여전히 권한이 허용되지 않은 경우 종료
      }
    }

    // 현재 위치 가져오기
    await location.getLocation().then((value) {
      setState(() {
        // 가져온 위도와 경도로 상태 업데이트
        lat = value.latitude!;
        lng = value.longitude!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text("위도: $lat, 경도: $lng"), // 위도와 경도 표시
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("내 위치 찾기"),
                onPressed: () => _locateMe(), // 위치 검색을 트리거하는 버튼
              ),
            )
          ],
        ),
      ), 
    );
  }
}


