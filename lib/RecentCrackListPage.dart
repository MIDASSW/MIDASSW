import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RecentCrackListPage extends StatefulWidget {
  const RecentCrackListPage({super.key});

  @override
  _RecentCrackListPageState createState() => _RecentCrackListPageState();
}

class _RecentCrackListPageState extends State<RecentCrackListPage> {
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
      final List<dynamic> crackData = json.decode(response.body).take(10).toList(); 
      setState(() {
        cracks = crackData.map((data) => Crack.fromJson(data)).toList();
        cracks.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp))); 
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load cracks');
    }
  }

  String formatDate(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd').format(dt); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
  title: const Text(
    '최근 크랙',
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
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
                                style: const TextStyle(fontWeight: FontWeight.bold), 
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.network(
                              crack.imageUrl,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 10), 
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '일시: ',
                                        style: TextStyle(fontWeight: FontWeight.bold), 
                                      ),
                                      Expanded(
                                        child: Text(
                                          formatDate(crack.timestamp),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '위치: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          crack.title,
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
      distance: (json['id'] % 10).toDouble(),
    );
  }
}
