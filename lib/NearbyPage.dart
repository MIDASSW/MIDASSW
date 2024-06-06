import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// 다른 페이지로 이동할 수 있도록 새 페이지 생성
class RecentCrackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('최근 크랙'),
      ),
      body: Center(
        child: Text('최근 크랙 페이지입니다.'),
      ),
    );
  }
}

class NearbyPage extends StatefulWidget {
  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  List<Crack> cracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCracks();
  }

  Future<void> fetchCracks() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      final List<dynamic> crackData = json.decode(response.body).take(10).toList(); // 상위 10개 데이터만 사용
      setState(() {
        cracks = crackData.map((data) => Crack.fromJson(data)).toList();
        cracks.sort((a, b) => a.distance.compareTo(b.distance)); // 임의의 거리 정렬
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load cracks');
    }
  }

  String formatDate(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd').format(dt); // 시간 없이 날짜만 반환
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('최근 크랙'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecentCrackPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('내 주변 크랙'),
                onTap: () {
                  Navigator.of(context).pop();
                  // 내 주변 크랙 페이지 그대로 유지
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text(
            '내 주변 크랙',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _showDialog,
          ),
        ],
        elevation: 0, // 스크롤 시 앱바의 그림자를 없앰
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: cracks.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300), // 더 연한 항목 구분선
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return ListTile(
                        title: Row(
                          children: [
                            SizedBox(
                              width: 24, // 숫자의 너비를 고정
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontWeight: FontWeight.bold), // 숫자를 볼드체로 표시
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.network(
                              crack.imageUrl,
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(width: 10), // 간격 추가
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '일시: ',
                                        style: TextStyle(fontWeight: FontWeight.bold), // "일시"를 볼드체로 표시
                                      ),
                                      Text('${formatDate(crack.timestamp)}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '위치: ',
                                        style: TextStyle(fontWeight: FontWeight.bold), // "위치"를 볼드체로 표시
                                      ),
                                      Text('${crack.title}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Crack {
  final String imageUrl;
  final String timestamp;
  final String title;
  final double distance;

  Crack({
    required this.imageUrl,
    required this.timestamp,
    required this.title,
    required this.distance,
  });

  factory Crack.fromJson(Map<String, dynamic> json) {
    return Crack(
      imageUrl: json['url'],
      timestamp: DateTime.now().toString(),
      title: json['title'],
      distance: (json['id'] % 10).toDouble(), // 임의의 거리 값 설정
    );
  }
}
