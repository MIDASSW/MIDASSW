import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
                title: const Text('사진 불러오기', style: TextStyle(color: Colors.black), ),
                
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
        }
      }
      else {
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
  backgroundColor: const Color.fromARGB(255, 233, 233, 233),
  appBar: PreferredSize(
  preferredSize: Size.fromHeight(100),
child: AppBar(
  backgroundColor: const Color.fromARGB(255, 233, 233, 233),
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
          '제보 하기', // 첫 번째 텍스트
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
          '주변에서 발생된 크랙을 제보해보세요!', // 두 번째 텍스트
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
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(30), // 왼쪽 상단 모서리 둥글게
    topRight: Radius.circular(30), // 오른쪽 상단 모서리 둥글게
  ),
  child: Container(
    color: const Color.fromARGB(255, 255, 255, 255), // ClipRRect 내부의 배경색 설정
    height: double.infinity, // 높이를 화면 전체로 확장
    child: SingleChildScrollView(
      child: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center, // 자식이 화면 전체 너비를 차지하도록 설정
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showImagePickerDialog,
              child: _image == null? 
              Container(
  width: 250,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: Colors.grey[400]!),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
        spreadRadius: 2, // 그림자 퍼지는 정도
        blurRadius: 5,   // 그림자 흐림 정도
        offset: Offset(0, 3), // 그림자의 위치 (x, y)
      ),
    ],
  ),
  child: Stack(
    children: [
      // 중앙의 이미지 아이콘
      Center(
        child: const ImageIcon(
          AssetImage('assets/image/doro2.png'),
          size: 200,
        ),
      ),
      // 오른쪽 아래의 + 아이콘
      Positioned(
        bottom: 10, // 아래쪽 여백
        right: 10,  // 오른쪽 여백
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // 아이콘 배경색
            shape: BoxShape.circle, // 원형 배경
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
            onPressed: () {
            },
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
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
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
                    icon: const Icon(Icons.date_range, color: Color.fromARGB(255, 83, 83, 83)),
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
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
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
                    icon: const Icon(Icons.location_on, color: Color.fromARGB(255, 83, 83, 83)),
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
              child: const Text('전송하기', style: TextStyle(color: Colors.white, fontSize: 16)),
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
