import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputDummyMotor extends StatelessWidget {
  const InputDummyMotor({super.key});

  void addDummyData() async {
    final dummyMotors = [
      {
        'nama': 'Honda EM1:',
        'platNomor': 'B 1234 EML',
        'status': 'tersedia',
        'latitude': -6.3019,
        'longitude': 106.8166,
        'statusBaterai': 85,
        'jarakTersedia': 30.0,
      },
      {
        'nama': 'Yamaha E01',
        'platNomor': 'B 5678 YME',
        'status': 'tersedia',
        'latitude': -6.3025,
        'longitude': 106.8170,
        'statusBaterai': 60,
        'jarakTersedia': 20.0,
      },
      {
        'nama': 'Viar Q1',
        'platNomor': 'B 9101 VRQ',
        'status': 'tersedia',
        'latitude': -6.3030,
        'longitude': 106.8180,
        'statusBaterai': 45,
        'jarakTersedia': 15.0,
      }
    ];

    final db = FirebaseFirestore.instance;
    for (var motor in dummyMotors) {
      await db.collection('motors').add(motor);
    }

    print("✅ Dummy data berhasil ditambahkan!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Data Dummy')),
      body: Center(
        child: ElevatedButton(
          onPressed: addDummyData,
          child: const Text("Tambah 3 Data Motor Dummy"),
        ),
      ),
    );
  }
}
