import 'dart:async'; // Completer를 사용하기 위해 필요합니다.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지를 가져옵니다.
import 'package:location/location.dart' as loc; // 위치 관련 기능을 사용하기 위해 필요합니다.

class LocatPage extends StatefulWidget {
  const LocatPage({super.key});

  @override
  _LocatPageState createState() => _LocatPageState();
}

class _LocatPageState extends State<LocatPage> {
  final Completer<GoogleMapController> _controllerCompleter = Completer(); // GoogleMapController를 완성하기 위한 Completer 객체입니다.
  late GoogleMapController _mapController; // GoogleMapController 객체입니다.
  loc.Location location = loc.Location(); // Location 객체를 생성합니다.

  // 마커를 저장할 Set을 선언합니다.
  final Set<Marker> _markers = {};

  // 초기 카메라 위치를 설정합니다. (서울의 특정 좌표)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.50508097213444, 126.95493073306663),
    zoom: 14, // 줌 레벨을 14로 조정하여 더 넓은 영역이 보이도록 설정
  );

  @override
  void initState() {
    super.initState();
    _requestPermission(); // 위치 권한 요청을 초기화합니다.
  }

  @override
  void dispose() {
    // GoogleMapController 해제 또는 기타 필요에 따라 추가 자원 해제 코드
    _controllerCompleter.future.then((controller) {
      controller.dispose();
    });

    super.dispose();
  }

  // 위치 권한을 요청하는 함수입니다.
  void _requestPermission() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // 위치 서비스가 켜져 있는지 확인합니다.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 꺼져 있으면, 켜도록 요청합니다.
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // 위치 서비스가 여전히 꺼져 있으면 함수 종료
      }
    }

    // 위치 권한이 있는지 확인합니다.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      // 위치 권한이 거부되었으면, 다시 요청합니다.
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return; // 위치 권한이 여전히 거부되었으면 함수 종료
      }
    }

    _getCurrentLocation(); // 현재 위치를 가져옵니다.
  }

  // 현재 위치를 가져오고 마커를 추가하는 함수입니다.
  void _getCurrentLocation() async {
    final currentLocation = await location.getLocation(); // 현재 위치를 가져옵니다.

    if (mounted) {
      _addMarker(currentLocation.latitude!, currentLocation.longitude!);
    }
  }

  void _addMarker(double latitude, double longitude) async {
    final marker = Marker(
      markerId: const MarkerId("current_location"),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(),
    );

    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.add(marker);
      });
    }

    // GoogleMapController가 완성되었는지 확인합니다.
    if (_controllerCompleter.isCompleted) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude), // 현재 위치로 카메라 이동
          zoom: 18.0, // 줌 레벨을 18로 설정하여 더 세밀한 뷰를 제공합니다.
        ),
      ));
    } else {
      _controllerCompleter.future.then(
        (controller) {
          _mapController = controller;
          if (mounted) {
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(latitude, longitude), // 현재 위치로 카메라 이동
                  zoom: 18.0, // 줌 레벨을 18로 설정하여 더 세밀한 뷰를 제공합니다.
                ),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal, // 지도 타입을 일반 모드로 설정합니다.
        initialCameraPosition: _initialPosition, // 초기 카메라 위치를 설정합니다.
        onMapCreated: (GoogleMapController controller) {
          if (!_controllerCompleter.isCompleted) {
            _controllerCompleter.complete(controller); // GoogleMapController를 Completer에 전달합니다.
            _mapController = controller; // GoogleMapController를 저장합니다.
          }
        },
        markers: _markers, // GoogleMap 위젯에 마커 Set을 전달합니다.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation, // 버튼을 누르면 현재 위치를 가져옵니다.
        tooltip: '현재 위치', // 툴팁을 설정합니다.
        backgroundColor: const Color.fromARGB(255, 215, 215, 215), // 버튼 배경색을 설정합니다.
        child: const Icon(Icons.my_location), // 버튼 아이콘을 설정합니다.
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // 버튼 위치를 왼쪽에 배치합니다.
    );
  }
}

