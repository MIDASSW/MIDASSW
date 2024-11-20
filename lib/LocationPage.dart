import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:location/location.dart' as loc; 

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controllerCompleter = Completer(); 
  late GoogleMapController _mapController; 
  loc.Location location = loc.Location(); 

  
  final Set<Marker> _markers = {};

 
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.50508097213444, 126.95493073306663),
    zoom: 14, 
  );

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
   
    _controllerCompleter.future.then((controller) {
      controller.dispose();
    });

    super.dispose();
  }


  void _requestPermission() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;


    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
 
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; 
      }
    }


    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
   
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return; 
      }
    }

    _getCurrentLocation(); 
  }

 
  void _getCurrentLocation() async {
    final currentLocation = await location.getLocation(); 

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

   
    if (_controllerCompleter.isCompleted) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude), 
          zoom: 18.0, 
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
                  target: LatLng(latitude, longitude), 
                  zoom: 18.0, 
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
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition, 
        onMapCreated: (GoogleMapController controller) {
          if (!_controllerCompleter.isCompleted) {
            _controllerCompleter.complete(controller); 
            _mapController = controller; 
          }
        },
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation, 
        tooltip: '현재 위치', 
        backgroundColor: const Color.fromARGB(255, 215, 215, 215),
        child: const Icon(Icons.my_location), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

