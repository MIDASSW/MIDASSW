
import 'package:flutter/material.dart';
import 'package:flutter_crackdetectcamera/PasswordChangePage.dart';
import 'package:flutter_crackdetectcamera/SoundLevelDialog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _firstToggle = false;
  bool _thirdToggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: TextStyle(fontWeight: FontWeight.bold),
        ),  backgroundColor:Colors.white, centerTitle: true),
        backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
   Container(
          width: 300,  // 알림크기설정과 동일한 너비
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFefefef), // 배경 색상 변경
            borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "직접 알림",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _firstToggle,
                    onChanged: (value) {
                      setState(() {
                        _firstToggle = value;
                        // 크랙이 감지될때, 알림소리 내기
                        
                      });
                    },
                    inactiveTrackColor: Colors.white,
                    activeTrackColor: Colors.blue.withOpacity(0.5), // 활성화 시 트랙 색상
                    activeColor: Colors.blue, // 활성화 시 스위치 색상
                  ),
                ],
              ),
              SizedBox(height: 8),  // 텍스트와 토글 간격
              Text(
                "50~200m 내에 크랙이 감지될때,알림 소리가 나요.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // 끝: 직접알림 컨테이너
        SizedBox(height: 35),
        // 시작: IgnorePointer
        IgnorePointer(
          ignoring: !_firstToggle,
          child: GestureDetector(
            onTap: _firstToggle ? () { print('알림크기설정 클릭됨'); } : null,
            child: Opacity(
              opacity: _firstToggle ? 1.0 : 0.5,
              child: Container(
                width: 300,  // Increased width
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFefefef),  // Changed color to efefef
                  borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '알림 크기 설정',
                      style: TextStyle(fontSize: 16, color: Colors.black), // 동일한 스타일 적용
                    ),
                              IconButton(
            onPressed: _firstToggle
                ? () {
                    print('알림크기설정 클릭됨');
                    //다이얼로그 팝업
                            showDialog(
          context: context,
          builder: (BuildContext context) {
 return SoundLevelDialog();



          },
        );

                    
                  }
                : null,
            icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),

                  ],
                ),
              ),
            ),
          ),
        ),
        // 끝: IgnorePointer

            SizedBox(height: 35),
        Container(
          width: 300,  // 알림크기설정과 동일한 너비
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFefefef), // 배경 색상 변경
            borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "푸시알림",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _thirdToggle,
                    onChanged: (value) {
                      setState(() {
                        _thirdToggle = value;
                      });
                    },
                    inactiveTrackColor: Colors.white,
                    activeTrackColor: Colors.blue.withOpacity(0.5), // 활성화 시 트랙 색상
                    activeColor: Colors.blue, // 활성화 시 스위치 색상
                  ),
                ],
              ),
              SizedBox(height: 8),  // 텍스트와 토글 간격
              Text(
                "1km내에 크랙이 감지 될 때, 푸시알림을 보내요.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
            SizedBox(height: 35),
        // 시작: Container
        Container(
          width: 300,  // Increased width
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFFefefef),  // Changed color to efefef
            borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
          ),
          padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '비밀번호 변경',
                      style: TextStyle(fontSize: 16, color: Colors.black), // 동일한 스타일 적용
                    ),
                    IconButton(
                      onPressed:  () {
                        print('비밀번호변경 클릭됨');
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PasswordChangePage(),));
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ],
                ),
        ),
        // 끝: Container
          ],
        ),
      ),
    );
  }
}
//