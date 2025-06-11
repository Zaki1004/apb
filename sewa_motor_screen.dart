import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'models.dart';
import 'motor_service.dart';

class SewaMotorScreen extends StatefulWidget {
  const SewaMotorScreen({super.key});

  @override
  State<SewaMotorScreen> createState() => _SewaMotorScreenState();
}

class _SewaMotorScreenState extends State<SewaMotorScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Motor> daftarMotor = [];
  File? _fotoKTP;
  File? _fotoSIM;

  @override
  void initState() {
    super.initState();
    ambilDataMotor();
  }

  Future<void> ambilDataMotor() async {
    final snapshot = await db.collection('motors').get();
    final data = snapshot.docs.map((doc) {
      return Motor.fromMap(doc.id, doc.data());
    }).toList();

    setState(() {
      daftarMotor = data;
    });
  }

  Future<void> ambilGambar(bool untukKTP) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final XFile? foto = await picker.pickImage(source: ImageSource.camera);

      if (foto != null) {
        setState(() {
          if (untukKTP) {
            _fotoKTP = File(foto.path);
          } else {
            _fotoSIM = File(foto.path);
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin kamera diperlukan')),
      );
    }
  }

  void tampilkanDialogSewa(Motor motor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sewa ${motor.nama}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Plat Nomor: ${motor.platNomor}'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Foto KTP'),
              onPressed: () => ambilGambar(true),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Foto SIM'),
              onPressed: () => ambilGambar(false),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Konfirmasi Sewa'),
            onPressed: () {
              simpanDataSewa(motor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void simpanDataSewa(Motor motor) {
    if (_fotoKTP != null && _fotoSIM != null) {
      db.collection('transaksi_sewa').add({
        'motorId': motor.id,
        'namaMotor': motor.nama,
        'plat': motor.platNomor,
        'statusBaterai': motor.statusBaterai,
        'status': 'menunggu verifikasi',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permintaan sewa berhasil dikirim')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon upload KTP dan SIM terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Pilih Motor Listrik",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: daftarMotor.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarMotor.length,
              itemBuilder: (context, index) {
                final motor = daftarMotor[index];
                return InkWell(
                  onTap: () => tampilkanDialogSewa(motor),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2C36),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          child: motor.gambarUrl != null && motor.gambarUrl!.isNotEmpty
                              ? Image.network(
                                  motor.gambarUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[700],
                                    width: 120,
                                    height: 120,
                                    child: const Icon(Icons.broken_image, size: 40, color: Colors.white),
                                  ),
                                )
                              : Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey[700],
                                  child: const Icon(Icons.motorcycle, size: 40, color: Colors.white),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  motor.nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.white70),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Plat: ${motor.platNomor}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.battery_charging_full, size: 16, color: Colors.greenAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      motor.statusBaterai != null ? '${motor.statusBaterai}%' : 'Baterai N/A',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline, size: 16, color: Colors.lightBlueAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Status: ${motor.status}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.directions, size: 16, color: Colors.orangeAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Jarak: ${motor.jarakTersedia != null ? '${motor.jarakTersedia} km' : 'N/A'}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Lokasi: (${motor.latitude}, ${motor.longitude})',
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
