import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_crackdetectcamera/RecentCrackListPage.dart';
import 'package:flutter_crackdetectcamera/NearbyCrackListPage.dart';

class MyNearbyPage extends StatefulWidget {
  const MyNearbyPage({super.key});

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
        final List<dynamic> crackData = json.decode(response.body).take(5).toList();
        if (mounted) {
          setState(() {
            cracks = crackData.map((data) => Crack.fromJson(data)).toList();
            cracks.sort((a, b) => a.distance.compareTo(b.distance));
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
     
    }
  }

  String formatDate(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Scaffold의 전체 배경을 흰색으로 설정
  appBar: PreferredSize(
  preferredSize: Size.fromHeight(100),
child: AppBar(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black, // AppBar 텍스트 색상을 검정으로 설정
  automaticallyImplyLeading: false,
  elevation: 0,
  title: null, // 기본 title을 null로 설정하여 flexibleSpace에만 텍스트를 배치하도록 함
  flexibleSpace: Column(
    mainAxisAlignment: MainAxisAlignment.center, // Column 내부의 위젯들을 세로로 중앙 정렬
    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0), // 왼쪽 여백을 설정
        child: Text(
          '내 주변', // 첫 번째 텍스트
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0), // 두 번째 텍스트를 첫 번째 텍스트 아래에 배치
        child: Text(
          '최근 발생한 크랙과 내 주변 크랙을 확인해보세요!', // 두 번째 텍스트
          style: TextStyle(
            fontSize: 14, // 텍스트 크기
            color: Colors.black, // 텍스트 색상 설정
          ),
        ),
      ),
    ],
  ),
),


  ),

  body: ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30), // 왼쪽 상단 모서리 둥글게
      topRight: Radius.circular(30), // 오른쪽 상단 모서리 둥글게
    ),
    child: Container(
      color: const Color.fromARGB(255, 233, 233, 233), // body 부분의 배경색을 회색으로 설정
      child:SingleChildScrollView(
              child: Column(
        children: [
          SizedBox(
            height:25,
          ),
          ListTile(
            title: const Text('최근 크랙', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black87),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RecentCrackListPage()),
              );
            },
          ),
          SizedBox(
            height: 200,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cracks.length,
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              crack.imageUrl,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '일시: ${formatDate(crack.timestamp)}',
                              style: const TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '위치: ${crack.title}',
                              style: const TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          ListTile(
            title: const Text('내 주변 크랙', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black87),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NearbyCrackListPage()),
              );
            },
          ),
          SizedBox(
            height: 200,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cracks.length,
                    itemBuilder: (context, index) {
                      final crack = cracks[index];
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              crack.imageUrl,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '일시: ${formatDate(crack.timestamp)}',
                              style: const TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '위치: ${crack.title}',
                              style: const TextStyle(color: Colors.black87),
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
      )

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
      timestamp: DateTime.now().toString(),
      title: json['title'],
      distance: (json['id'] % 10).toDouble(), 
    );
  }
}
