import 'package:flutter/material.dart';

class MyRewardPage extends StatefulWidget {
  const MyRewardPage({super.key});

  @override
  _MyRewardPageState createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  int level = 1;
  int experience = 0;
  int points = 0;
  int attendanceDays = 0;
  DateTime selectedDate = DateTime.now();
  Map<DateTime, bool> attendance = {};
  Map<String, int> invitedFriendsAttendance = {};

  void addExperience() {
    setState(() {
      if (level < 10) {
        experience++;
        points += 1000 + (level - 1) * 100;
        if (experience >= 10) {
          points += 1000 + (level - 1) * 100; // 레벨업 보상 포인트 추가
          experience = 0;
          level++;
        }
      } else {
        points += 1000 + (level - 1) * 100; // 레벨 10에서도 계속 제보 포인트 지급
      }
    });
  }

  void markAttendance() {
    setState(() {
      DateTime todayWithoutTime =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      if (!attendance.containsKey(todayWithoutTime)) {
        attendance[todayWithoutTime] = true;
        attendanceDays++;
        points += 10;

        if (attendanceDays % 15 == 0) {
          points += 150; // 15일 출석 보너스
        }
        if (attendanceDays % 30 == 0) {
          points += 300; // 30일 출석 보너스
        }
      }
    });
  }

  void changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  void inviteFriend() {
showDialog(
  context: context,
  builder: (BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    return AlertDialog(
      title: Text('친구 초대'),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      content: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(hintText: '전화번호를 입력하세요'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            print(
                'Invited friend with phone number: ${phoneController.text}');
          },
          child: Text('초대하기'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // 텍스트 색상
            backgroundColor: Colors.black, // 버튼 배경색
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // 텍스트 색상
            backgroundColor: Colors.black, // 버튼 배경색
          ),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '내 보상',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: inviteFriend,
                  child: Text('친구 초대하기', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(width: 10),
                Text(
                  '포인트: $points 원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [],
      ),
      body: Container(
  color: Colors.white, // 배경색을 흰색으로 설정
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RewardLevelWidget(level: level, experience: experience),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onPressed: addExperience,
            child: Text('제보하기', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: markAttendance,
                child: Text('출석 체크', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => changeDate(-1),
              ),
              Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => changeDate(1),
              ),
            ],
          ),
          SizedBox(height: 20),
          CalendarWidget(
              attendance: attendance, selectedDate: selectedDate),
        ],
      ),
    ),
  ),
),
    );
  }
}

class RewardLevelWidget extends StatelessWidget {
  final int level;
  final int experience;

  RewardLevelWidget({required this.level, required this.experience});

  @override
  Widget build(BuildContext context) {
    int rewardPerReport = 1000 + (level - 1) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '현재 레벨: $level',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Row(
          children: List.generate(10, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  height: 20,
                  color: index < experience ? Colors.blue : Colors.grey[300],
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Text(
          '제보 1건당 $rewardPerReport원 지급',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final Map<DateTime, bool> attendance;
  final DateTime selectedDate;

  CalendarWidget({required this.attendance, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    int year = selectedDate.year;
    int month = selectedDate.month;

    List<Widget> days = [];
    int daysInMonth = DateUtils.getDaysInMonth(year, month);

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(year, month, i);
      bool isAttended = attendance[DateTime(year, month, i)] ?? false;

      days.add(Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isAttended ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            '$i',
            style: TextStyle(
              color: isAttended ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${year}년 ${month}월 달력',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          children: days,
        ),
      ],
    );
  }
}