import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportPage extends StatefulWidget {
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
            colorScheme: ColorScheme.light(
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
          title: Text('사진 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('사진 찍기'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('사진 불러오기'),
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

  // 이미지 선택 메서드
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

  // 위치 정보 가져오기 메서드
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

      final apiKey = dotenv.env['appKey']; // .env 파일에서 API 키 가져오기
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final formattedAddress = decoded['results'][0]['formatted_address'];
        if (mounted) {
          setState(() {
            address = formattedAddress;
            _locationController.text = address;
          });
        };
      } else {
        if (mounted) {
          setState(() {
            address = 'Failed to fetch address';
          });
        }
      }
    });
  }

  // 데이터를 서버로 전송하는 메서드
  Future<void> sendData() async {
    if (_image == null || _selectedDate == null || address.isEmpty) {
      // 모든 필드가 채워져 있는지 확인합니다.
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:3000/uploads')); // Node.js 서버 URL 
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    request.fields['date'] = _selectedDate!.toIso8601String();
    request.fields['location'] = address;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded successfully');
    } else {
      print('Failed to upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '제보하기',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              GestureDetector(
                onTap: _showImagePickerDialog, // 이미지 선택 다이얼로그 표시
                child: _image == null
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey,
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
              SizedBox(height: 20),
              Container(
                width: 300,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    TextField( // 날짜 입력 필드
                      decoration: InputDecoration(
                        labelText: '날짜',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
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
                      icon: Icon(Icons.date_range, color: Colors.grey),
                      onPressed: () => _selectDate(context), // 날짜 선택 다이얼로그 표시
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    TextField( // 위치 입력 필드
                      decoration: InputDecoration(
                        labelText: '위치',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      controller: _locationController,
                      readOnly: true,
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on, color: Colors.grey),
                      onPressed: () async {
                        await _locateMe(); // 위치 정보 가져오기
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  sendData(); // 서버로 데이터 전송
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 196, 196, 196),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(160, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text('전송하기', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
