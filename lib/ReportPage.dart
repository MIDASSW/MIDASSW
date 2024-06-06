import 'package:flutter/material.dart';
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
              primary: Colors.grey, // 선택된 날짜 색상
              onPrimary: Colors.white, // 선택된 날짜의 텍스트 색상
              surface: Colors.white, // 배경색
              onSurface: Colors.grey, // 텍스트 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // "취소"와 "확인" 버튼 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
      setState(() {
        lat = value.latitude!;
        lng = value.longitude!;
      });

      // 역지오코딩 수행
      final apiKey = 'AIzaSyBS9eBoziroOVJYfMoJ6iE6CZKcmA4DRZc'; // 구글 지오코딩 API 키
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final formattedAddress = decoded['results'][0]['formatted_address'];
        setState(() {
          address = formattedAddress;
          _locationController.text = address;
        });
      } else {
        setState(() {
          address = 'Failed to fetch address';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '제보하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15),
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: _image == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: 200,
                        color: Colors.grey,
                      )
                    : Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '날짜', // 힌트 텍스트 설정
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                              : '',
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '위치', // 힌트 텍스트 설정
                        ),
                        controller: _locationController,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        await _locateMe();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  //사진을 찍었을때 이미지를 저장할수 있도록 한다.
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 196, 196, 196),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(160, 20),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text('전송하기', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
