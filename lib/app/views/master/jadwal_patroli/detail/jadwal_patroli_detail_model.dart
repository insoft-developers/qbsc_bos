class JadwalPatroliDetailModel {
  final int id;
  final int patroliId;
  final String patroliName;
  final int locationId;
  final String locationName;
  final int urutan;
  final String jamAwal;
  final String jamAkhir;
  final int comid;
  final String comName;

  JadwalPatroliDetailModel({
    required this.id,
    required this.patroliId,
    required this.patroliName,
    required this.locationId,
    required this.locationName,
    required this.urutan,
    required this.jamAwal,
    required this.jamAkhir,
    required this.comid,
    required this.comName,
  });

  factory JadwalPatroliDetailModel.fromJson(Map<String, dynamic> json) {
    return JadwalPatroliDetailModel(
      id: json['id'],
      patroliId: json['patroli_id'] ?? 0,
      patroliName: json['jadwal']['name'] ?? '',
      locationId: json['location_id'] ?? 0,
      locationName: json['location']['nama_lokasi'] ?? '',
      urutan: json['urutan'] ?? 0,
      jamAwal: json['jam_awal'] ?? '',
      jamAkhir: json['jam_akhir'] ?? '',
      comid: json['comid'] ?? 0,
      comName: json['company']['company_name'] ?? '',
    );
  }
}
