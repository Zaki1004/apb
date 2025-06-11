import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapsBengkelScreen extends StatefulWidget {
  const MapsBengkelScreen({super.key});

  @override
  State<MapsBengkelScreen> createState() => _MapsBengkelScreenState();
}

class _MapsBengkelScreenState extends State<MapsBengkelScreen> {
  LatLng? _userLocation;

  final List<Map<String, dynamic>> _bengkelList = [
    {
      "nama": "Bengkel A",
      "latlng": LatLng(-6.2060685, 106.8338245),
    },
    {
      "nama": "Bengkel B",
      "latlng": LatLng(-6.1898, 106.7292),
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userLocation == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Memuat Peta...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Peta Lokasi ${widget}")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _userLocation!,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 60,
                height: 60,
                child: Icon(Icons.person_pin_circle,
                    size: 40, color: Colors.blue),
              ),
              ..._bengkelList.map((bengkel) => Marker(
                    point: bengkel['latlng'],
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Icon(Icons.build, size: 35, color: Colors.red),
                        Text(
                          bengkel['nama'],
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
