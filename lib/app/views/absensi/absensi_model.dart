class AbsensiModel {
  final int id;
  final String tanggal;
  final int satpamId;
  final String namaSatpam;
  final String? latitude;
  final String? longitude;
  final String jamMasuk;
  final String? jamKeluar;
  final int? shiftId;
  final String? shiftName;
  final String? jamSettingMasuk;
  final String? jamSettingPulang;
  final int status;
  final String? description;
  final String? catatanMasuk;
  final String? catatanKeluar;
  final int comid;
  final String namaPerusahaan;
  final String createdAt;

  AbsensiModel({
    required this.id,
    required this.tanggal,
    required this.satpamId,
    required this.namaSatpam,
    this.latitude,
    this.longitude,
    required this.jamMasuk,
    this.jamKeluar,
    this.shiftId,
    this.shiftName,
    this.jamSettingMasuk,
    this.jamSettingPulang,
    required this.status,
    this.description,
    this.catatanMasuk,
    this.catatanKeluar,
    required this.comid,
    required this.namaPerusahaan,
    required this.createdAt,
  });

  // Parsing dari JSON
  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      id: json['id'],
      tanggal: json['tanggal'],
      satpamId: json['satpam_id'],
      namaSatpam: json['satpam']['name'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      jamMasuk: json['jam_masuk'],
      jamKeluar: json['jam_keluar'],
      shiftId: json['shift_id'],
      shiftName: json['shift_name'],
      jamSettingMasuk: json['jam_setting_masuk'],
      jamSettingPulang: json['jam_setting_pulang'],
      status: json['status'],
      description: json['description'],
      catatanMasuk: json['catatan_masuk'],
      catatanKeluar: json['catatan_keluar'],
      comid: json['comid'],
      namaPerusahaan: json['company']['company_name'] ?? '',
      createdAt: json['created_at'],
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'satpam_id': satpamId,
      'latitude': latitude,
      'longitude': longitude,
      'jam_masuk': jamMasuk,
      'jam_keluar': jamKeluar,
      'shift_id': shiftId,
      'shift_name': shiftName,
      'jam_setting_masuk': jamSettingMasuk,
      'jam_setting_pulang': jamSettingPulang,
      'status': status,
      'description': description,
      'catatan_masuk': catatanMasuk,
      'catatan_keluar': catatanKeluar,
      'comid': comid,
      'created_at': createdAt,
    };
  }
}
