class SatpamAbsensiModel {
  final int id;
  final String tanggal;
  final String? latitude;
  final String? longitude;
  final String satpamName;
  final String? jamMasuk;
  final String? foto;
  final String whatsapp;
  final String? shiftName;

  SatpamAbsensiModel({
    required this.id,
    required this.tanggal,
    this.latitude,
    this.longitude,
    required this.satpamName,
    this.jamMasuk,
    this.foto,
    required this.whatsapp,
    this.shiftName,
  });

  factory SatpamAbsensiModel.fromJson(Map<String, dynamic> json) {
    return SatpamAbsensiModel(
      id: json['id'],
      tanggal: json['tanggal'],
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
      satpamName: json['satpam']['name'] ?? '',
      jamMasuk: json['jam_masuk'] ?? '',
      foto: json['satpam']['face_photo_path'] ?? '',
      whatsapp: json['satpam']['whatsapp'] ?? '',
      shiftName: json['shift_name'] ?? '',
    );
  }
}
