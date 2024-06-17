import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NearbyCrackListPage extends StatefulWidget {
  @override
  _NearbyCrackListPageState createState() => _NearbyCrackListPageState();
}

class _NearbyCrackListPageState extends State<NearbyCrackListPage> {
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
        cracks.sort((a, b) => a.distance.compareTo(b.distance)); // 내 위치와 가까운 순으로 정렬
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
        elevation: 0, // 스크롤 시 앱바의 그림자를 없앰
      ),
      resizeToAvoidBottomInset: false, // 키보드가 올라올 때 화면 크기 조정 안 함
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cracks.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return ListTile(
                        title: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.network(
                              crack.imageUrl,
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '일시: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${formatDate(crack.timestamp)}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '위치: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${crack.title}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
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
          ],
        ),
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
      timestamp: DateTime.now().toString(), // 실제 데이터가 있다면 여기에 적절한 값을 사용해야 합니다.
      title: json['title'],
      distance: (json['id'] % 10).toDouble(), // 임의의 거리 값 설정
    );
  }
}
