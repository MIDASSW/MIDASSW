import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isToggled = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5; // 초기 볼륨 값을 0.5로 설정
  final String _volumeKey = 'volume'; // SharedPreferences 키

  @override
  void initState() {
    super.initState();
    _loadVolume();
  }

  // 사용자가 설정한 볼륨 값을 로드합니다.
  Future<void> _loadVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _volume = prefs.getDouble(_volumeKey) ?? 0.5;
    });
  }

  // 사용자가 설정한 볼륨 값을 저장합니다.
  Future<void> _saveVolume(double volume) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, volume);
  }

  void _toggleButton(bool value) {
    setState(() {
      _isToggled = value;
    });

    // 특정 조건을 확인하고 알림 소리 재생
    if (_isToggled) {
      _playSound();
    } else {
      _audioPlayer.stop(); // 토글이 꺼지면 소리 중지
    }
  }

  void _playSound() async {
    await _audioPlayer.setVolume(_volume); // 현재 볼륨 설정
    await _audioPlayer.play(AssetSource('alarm_warning.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: SingleChildScrollView( // 스크롤 가능하도록 설정
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: _isToggled,
                onChanged: _toggleButton,
              ),
              Text(
                _isToggled ? 'Toggle is ON' : 'Toggle is OFF',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Volume: ${(_volume * 100).round()}%',
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(_volume * 100).round()}%',
                onChanged: (double value) {
                  setState(() {
                    _volume = value;
                  });
                  _audioPlayer.setVolume(_volume); // 슬라이더 이동 시 즉시 볼륨 조절
                  _saveVolume(value); // 설정한 볼륨 값을 저장
                },
              ),
              SizedBox(height: 20), // 슬라이더와 컨테이너 사이의 간격
              Container(
                width: double.infinity,
                height: 200, // 컨테이너의 높이 설정
                color: Colors.blue, // 컨테이너의 배경색 설정
                child: Center(
                  child: Text(
                    'This is a large container',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 20), // 큰 컨테이너와 추가 컨테이너 사이의 간격
              Container(
                width: double.infinity,
                height: 600, // 큰 컨테이너의 높이 설정
                color: Colors.green, // 큰 컨테이너의 배경색 설정
                child: Center(
                  child: Text(
                    'This is a scrollable container',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
