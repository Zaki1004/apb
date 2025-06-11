class Motor {
  final String id;
  final String nama;
  final String platNomor;
  final String status;
  final double latitude;
  final double longitude;
  final int? statusBaterai;
  final double? jarakTersedia;
  final String? gambarUrl;

  Motor({
    required this.id,
    required this.nama,
    required this.platNomor,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.statusBaterai,
    this.jarakTersedia,
    this.gambarUrl,
  });

  factory Motor.fromMap(String id, Map<String, dynamic> data) {
    return Motor(
      id: id,
      nama: data['nama'],
      platNomor: data['platNomor'],
      status: data['status'],
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      statusBaterai: data['statusBaterai'],
      jarakTersedia: data['jarakTersedia'] != null ? (data['jarakTersedia'] as num).toDouble() : null,
      gambarUrl: data['gambarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'platNomor': platNomor,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'statusBaterai': statusBaterai,
      'jarakTersedia': jarakTersedia,
      'gambarUrl': gambarUrl,
    };
  }
}
