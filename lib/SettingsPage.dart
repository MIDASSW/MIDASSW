import 'package:flutter/material.dart';
import 'package:flutter_crackdetectcamera/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_crackdetectcamera/PasswordChangePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _firstToggle = false;
  bool _thirdToggle = false;
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
      _firstToggle = value;
    });

    // 토글이 켜졌을 때 조건을 확인하고 소리 재생
    if (_firstToggle) {
      _checkConditionAndPlaySound();
    } else {
      _audioPlayer.stop(); // 토글이 꺼지면 소리 중지
    }
  }

  // 특정 조건을 확인하고 소리를 재생하는 메서드
  void _checkConditionAndPlaySound() {
    if (_firstToggle) {
      // 원하는 조건 추가
      bool conditionMet = false; // 예제에서는 항상 참으로 설정 여기서 크랙이 50~200m내에 크랙이 감지되면 소리가 나는 코드 짜면 됩니다.

      if (conditionMet) {
        _playSound();
      }
    }
  }

  void _playSound() async {
    await _audioPlayer.setVolume(_volume); // 현재 볼륨 설정
    await _audioPlayer.play(AssetSource('audio/alarm_warning.mp3'));
  }

  void _stopSound() async {
    await _audioPlayer.stop(); // 소리 중지
  }

  void _togglePushNotification(bool value) {
    setState(() {
      _thirdToggle = value;
    });

    if (_thirdToggle) {
      // _firebaseMessaging.subscribeToTopic('crack_detection'); **
    } else {
      // _firebaseMessaging.unsubscribeFromTopic('crack_detection'); **
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 로그아웃 로직 추가
                print('로그아웃 확인됨');
                // 예시: 로그인 페이지로 이동
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(), // LoginPage로 대체해야 합니다.
                ));
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
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
                            _toggleButton(value);
                          },
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: Colors.blue.withOpacity(0.5), // 활성화 시 트랙 색상
                          activeColor: Colors.blue, // 활성화 시 스위치 색상
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // 텍스트와 토글 간격
                    Text(
                      "50~200m내에 크랙이 감지될때, 알림 소리가 나요.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              IgnorePointer(
                ignoring: !_firstToggle,
                child: GestureDetector(
                  onTap: _firstToggle
                      ? () {
                          print('알림크기설정 클릭됨');
                          // 다이얼로그 팝업
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SoundLevelDialog(
                                volume: _volume,
                                onVolumeChanged: (double value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _audioPlayer.setVolume(_volume); // 슬라이더 이동 시 즉시 볼륨 조절
                                  _saveVolume(value); // 설정한 볼륨 값을 저장
                                },
                                playSound: _playSound, // 슬라이더 이동 시 소리 재생
                                stopSound: _stopSound, // 다이얼로그 닫을 때 소리 중지
                              );
                            },
                          );
                        }
                      : null,
                  child: Opacity(
                    opacity: _firstToggle ? 1.0 : 0.5,
                    child: Container(
                      width: 300,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFefefef), // Changed color to efefef
                        borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '알림 크기 설정',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: _firstToggle
                                ? () {
                                    print('알림크기설정 클릭됨');
                                    // 다이얼로그 팝업
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SoundLevelDialog(
                                          volume: _volume,
                                          onVolumeChanged: (double value) {
                                            setState(() {
                                              _volume = value;
                                            });
                                            _audioPlayer.setVolume(_volume); // 슬라이더 이동 시 즉시 볼륨 조절
                                            _saveVolume(value); // 설정한 볼륨 값을 저장
                                          },
                                          playSound: _playSound, // 슬라이더 이동 시 소리 재생
                                          stopSound: _stopSound, // 다이얼로그 닫을 때 소리 중지
                                        );
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
              SizedBox(height: 15),
              Container(
                width: 300,
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
                            _togglePushNotification(value);
                          },
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: Colors.blue.withOpacity(0.5), // 활성화 시 트랙 색상
                          activeColor: Colors.blue, // 활성화 시 스위치 색상
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // 텍스트와 토글 간격
                    Text(
                      "1km내에 크랙이 감지 될 때, 푸시알림을 보내요.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFefefef), // Changed color to efefef
                  borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '비밀번호 변경',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        print('비밀번호변경 클릭됨');
                        // Navigate to PasswordChangePage (Assuming you have a PasswordChangePage)
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PasswordChangePage(),
                        ));
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFefefef), // Changed color to efefef
                  borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Assuming you have a dialog for setting sound level
class SoundLevelDialog extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback playSound;
  final VoidCallback stopSound; // 소리 중지 콜백 추가

  SoundLevelDialog({
    required this.volume,
    required this.onVolumeChanged,
    required this.playSound,
    required this.stopSound,
  });

  @override
  _SoundLevelDialogState createState() => _SoundLevelDialogState();
}

class _SoundLevelDialogState extends State<SoundLevelDialog> {
  late double _currentVolume;

  @override
  void initState() {
    super.initState();
    _currentVolume = widget.volume;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('알림 소리 크기 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Volume: ${(_currentVolume * 100).round()}%',
            style: TextStyle(fontSize: 20),
          ),
          Slider(
            value: _currentVolume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(_currentVolume * 100).round()}%',
            onChanged: (double value) {
              setState(() {
                _currentVolume = value;
              });
              widget.onVolumeChanged(value);
              widget.playSound(); // 슬라이더 이동 시 소리 재생
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onVolumeChanged(_currentVolume); // 닫기 버튼을 눌렀을 때 볼륨 저장
            widget.stopSound(); // 닫기 버튼을 눌렀을 때 소리 중지
            Navigator.of(context).pop();
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}

// Assuming you have a LoginPage for logout navigation
