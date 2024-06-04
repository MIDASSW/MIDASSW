import 'package:flutter/material.dart';

class SoundLevelDialog extends StatefulWidget {
  @override
  _SoundLevelDialogState createState() => _SoundLevelDialogState();
}

class _SoundLevelDialogState extends State<SoundLevelDialog> {
  double _soundLevel = 3.0; // 초기 소리 레벨

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // 배경색을 흰색으로 변경
      title: Text(
        '알림 크기 설정',
        style: TextStyle(fontSize: 14), // 텍스트 크기를 줄임
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.volume_down, size: 16, color: Colors.grey), // 작은 확성기 아이콘 및 색상 변경
                SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.black, // 슬라이더 색상 변경
                      inactiveTrackColor: Colors.black.withOpacity(0.3),
                      thumbColor: Colors.black, // 선택 원 색상 변경
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0), // 선택 원 크기 줄임
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
                    ),
                    child: Slider(
                      value: _soundLevel, // null 체크 제거
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (value) {
                        setState(() {
                          _soundLevel = value;
                        });
                      },
                    ),
                  ),
                ),
                Icon(Icons.volume_up, size: 24), // 큰 확성기 아이콘
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('닫기',style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

// 이 함수는 다이얼로그를 표시하기 위해 사용됩니다.
Future<void> showSoundLevelDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SoundLevelDialog();
    },
  );
}