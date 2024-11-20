import 'package:flutter/material.dart';
import 'package:flutter_crackdetectcamera/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_crackdetectcamera/PasswordChangePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _firstToggle = false;
  bool _thirdToggle = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5; 
  final String _volumeKey = 'volume'; 

  @override
  void initState() {
    super.initState();
    _loadVolume();
  }

  
  Future<void> _loadVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _volume = prefs.getDouble(_volumeKey) ?? 0.5;
    });
  }


  Future<void> _saveVolume(double volume) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, volume);
  }

  void _toggleButton(bool value) {
    setState(() {
      _firstToggle = value;
    });

 
    if (_firstToggle) {
      _checkConditionAndPlaySound();
    } else {
      _audioPlayer.stop();
    }
  }


  void _checkConditionAndPlaySound() {
    if (_firstToggle) {
     
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
        backgroundColor: Colors.white,
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
             
              print('로그아웃 확인됨');
            
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(), 
                ),
                (Route<dynamic> route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: const Text('확인'),
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
        title: const Text(
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFefefef),
                  borderRadius: BorderRadius.circular(15), 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "직접 알림",
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: _firstToggle,
                          onChanged: (value) {
                            _toggleButton(value);
                          },
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: Colors.blue.withOpacity(0.5),
                          activeColor: Colors.blue, 
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), 
                    const Text(
                      "50~200m내에 크랙이 감지될때, 알림 소리가 나요.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              IgnorePointer(
                ignoring: !_firstToggle,
                child: GestureDetector(
                  onTap: _firstToggle
                      ? () {
                          print('알림크기설정 클릭됨');
                          
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SoundLevelDialog(
                                volume: _volume,
                                onVolumeChanged: (double value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _audioPlayer.setVolume(_volume);
                                  _saveVolume(value); 
                                },
                                playSound: _playSound, 
                                stopSound: _stopSound, 
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
                        color: const Color(0xFFefefef), 
                        borderRadius: BorderRadius.circular(15), 
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                            _audioPlayer.setVolume(_volume);
                                            _saveVolume(value); 
                                          },
                                          playSound: _playSound, 
                                          stopSound: _stopSound, 
                                        );
                                      },
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFefefef), 
                  borderRadius: BorderRadius.circular(15), 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "푸시알림",
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: _thirdToggle,
                          onChanged: (value) {
                            _togglePushNotification(value);
                          },
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: Colors.blue.withOpacity(0.5),
                          activeColor: Colors.blue, 
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // 텍스트와 토글 간격
                    const Text(
                      "1km내에 크랙이 감지 될 때, 푸시알림을 보내요.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFefefef),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '비밀번호 변경',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        print('비밀번호변경 클릭됨');
                       
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PasswordChangePage(),
                        ));
                      },
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFefefef), 
                  borderRadius: BorderRadius.circular(15), 
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
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


class SoundLevelDialog extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback playSound;
  final VoidCallback stopSound; 

  const SoundLevelDialog({super.key, 
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
    backgroundColor: Colors.white, 
    title: const Text('알림 소리 크기 설정'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Volume: ${(_currentVolume * 100).round()}%',
          style: const TextStyle(fontSize: 20),
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
            widget.playSound();
          },
          activeColor: Colors.grey, 
          inactiveColor: Colors.grey[300], 
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          widget.onVolumeChanged(_currentVolume); 
          widget.stopSound(); 
          Navigator.of(context).pop();
        },
          style: TextButton.styleFrom(
    foregroundColor: Colors.black, 
  ),
        child: const Text('닫기'),
      ),
    ],
  );
}

}


