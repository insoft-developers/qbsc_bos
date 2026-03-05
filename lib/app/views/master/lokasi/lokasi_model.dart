class LokasiModel {
  final int id;
  final String qrcode;
  final String namaLokasi;
  final String latitude;
  final String longitude;
  final int isActive;
  final String comid;
  final String comName;

  LokasiModel({
    required this.id,
    required this.qrcode,
    required this.namaLokasi,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.comid,
    required this.comName,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id'],
      qrcode: json['qrcode'] ?? '',
      namaLokasi: json['nama_lokasi'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      isActive: json['is_active'] ?? 0,
      comid: json['comid'] ?? '0',
      comName: json['company']['company_name'] ?? '',
    );
  }
}
