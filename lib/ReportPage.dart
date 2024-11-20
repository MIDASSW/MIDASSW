import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? _selectedDate;
  File? _image;
  double lat = 0;
  double lng = 0;
  String address = '';
  Location location = Location();
  bool _serviceEnabled = true;
  late PermissionStatus _permissionGranted;

  final TextEditingController _locationController = TextEditingController();

  // 날짜 선택 메서드
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('ko', 'KR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.grey,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      if (mounted) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    }
  }

  // 이미지 선택 다이얼로그 표시 메서드
  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('사진 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text(
                  '사진 찍기',
                  style: TextStyle(color: Colors.black), // 텍스트 색상을 검정색으로 설정
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  '사진 불러오기',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (mounted) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then((value) async {
      if (mounted) {
        setState(() {
          lat = value.latitude!;
          lng = value.longitude!;
        });
      }

      final apiKey = dotenv.env['appKey'];
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final formattedAddress = decoded['results'][0]['formatted_address'];
        if (mounted) {
          setState(() {
            address = formattedAddress;
            _locationController.text = address;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            address = 'Failed to fetch address';
          });
        }
      }
    });
  }

  Future<void> sendData() async {
    if (_image == null || _selectedDate == null || address.isEmpty) {
      return;
    }

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://midassw.onrender.com/mobile/uploads'));

      // 파일 추가
      request.files.add(await http.MultipartFile.fromPath(
          'image', // 이 이름은 서버의 upload.single('image')와 일치해야 함
          _image!.path));

      // 필드 추가
      request.fields['timestamp'] =
          _selectedDate!.toIso8601String(); // 'date' 대신 'timestamp' 사용
      request.fields['location'] = address;

      // 디버깅을 위한 로그
      print('요청 URL: ${request.url}');
      print('전송할 데이터: ${request.fields}');

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 내용: $responseBody');

      if (response.statusCode == 200) {
        print('업로드 성공');
      } else {
        print('업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 233, 233, 233),
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 233, 233),
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: null,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '제보 하기',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                '주변에서 발생된 크랙을 제보해보세요!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    body: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showImagePickerDialog,
                  child: _image == null
                      ? Container(
                          width: 250,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[400]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: const ImageIcon(
                                  AssetImage('assets/image/doro2.png'),
                                  size: 200,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    color: Colors.black,
                                    iconSize: 20,
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 300,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: '날짜',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 83, 83, 83)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                              : '',
                        ),
                        readOnly: true,
                      ),
                      IconButton(
                        icon: const Icon(Icons.date_range,
                            color: Color.fromARGB(255, 83, 83, 83)),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: '위치',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 83, 83, 83)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        controller: _locationController,
                        readOnly: true,
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on,
                            color: Color.fromARGB(255, 83, 83, 83)),
                        onPressed: () async {
                          await _locateMe();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    sendData();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 39, 39, 39),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(160, 50),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '전송하기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
