import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_crackdetectcamera/RecentCrackListPage.dart';
import 'package:flutter_crackdetectcamera/NearbyCrackListPage.dart';

class MyNearbyPage extends StatefulWidget {
  @override
  _MyNearbyPageState createState() => _MyNearbyPageState();
}

class _MyNearbyPageState extends State<MyNearbyPage> {
  List<Crack> cracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCracks();
  }

  Future<void> fetchCracks() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      if (response.statusCode == 200) {
        final List<dynamic> crackData = json.decode(response.body).take(5).toList(); // 상위 5개 데이터만 사용
        if (mounted) {
          setState(() {
            cracks = crackData.map((data) => Crack.fromJson(data)).toList();
            cracks.sort((a, b) => a.distance.compareTo(b.distance)); // 위치 기준으로 정렬
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load cracks');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // 오류 처리를 추가할 수 있습니다.
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
        automaticallyImplyLeading: false,
        elevation: 0, // 스크롤 시 앱바의 그림자를 없앰
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('최근 크랙', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RecentCrackListPage()),
              );
            },
          ),
          SizedBox(
            height: 200,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cracks.length,
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return Container(
                        width: 150,
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              crack.imageUrl,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '일시: ${formatDate(crack.timestamp)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '위치: ${crack.title}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          ListTile(
            title: Text('내 주변 크랙', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NearbyCrackListPage()),
              );
            },
          ),
          SizedBox(
            height: 200,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cracks.length,
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return Container(
                        width: 150,
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              crack.imageUrl,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '일시: ${formatDate(crack.timestamp)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '위치: ${crack.title}',
                              overflow: TextOverflow.ellipsis,
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
      timestamp: DateTime.now().toString(), // 실제 데이터가 있다면 여기에 적절한 값을 사용해야 합니다.
      title: json['title'],
      distance: (json['id'] % 10).toDouble(), // 임의의 거리 값 설정
    );
  }
}
