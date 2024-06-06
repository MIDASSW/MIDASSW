import 'package:flutter/material.dart';

// SoundLevelDialog라는 StatefulWidget 정의
class SoundLevelDialog extends StatefulWidget {
  @override
  _SoundLevelDialogState createState() => _SoundLevelDialogState();
}

// SoundLevelDialog의 상태(State) 클래스 정의
class _SoundLevelDialogState extends State<SoundLevelDialog> {
  double _soundLevel = 3.0; // 초기 소리 레벨을 3.0으로 설정

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // 다이얼로그 배경색을 흰색으로 설정
      title: Text(
        '알림 크기 설정',
        style: TextStyle(fontSize: 14), // 다이얼로그 제목의 텍스트 크기를 14로 설정
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.volume_down, size: 16, color: Colors.grey), // 작은 확성기 아이콘을 회색으로 설정
                SizedBox(width: 8), // 아이콘과 슬라이더 사이에 간격 추가
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.black, // 슬라이더 활성 트랙 색상을 검정색으로 설정
                      inactiveTrackColor: Colors.black.withOpacity(0.3), // 슬라이더 비활성 트랙 색상을 검정색 투명도로 설정
                      thumbColor: Colors.black, // 슬라이더의 선택 원 색상을 검정색으로 설정
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0), // 선택 원 크기를 줄임
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0), // 오버레이 크기를 줄임
                    ),
                    child: Slider(
                      value: _soundLevel, // 현재 소리 레벨 값
                      min: 0, // 슬라이더 최소값
                      max: 5, // 슬라이더 최대값
                      divisions: 5, // 슬라이더의 단계 수
                      onChanged: (value) { // 슬라이더 값이 변경될 때 호출되는 콜백
                        setState(() {
                          _soundLevel = value; // 소리 레벨을 변경된 값으로 업데이트
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
            Navigator.of(context).pop(); // 닫기 버튼을 누르면 다이얼로그 닫기
          },
          child: Text('닫기', style: TextStyle(color: Colors.black)), // 닫기 버튼 텍스트 색상 설정
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
      return SoundLevelDialog(); // SoundLevelDialog 위젯을 빌드하여 다이얼로그로 표시
    },
  );
}
