class JamShiftModel {
  final int id;
  final String name;
  final String? jamMasukAwal;
  final String jamMasuk;
  final String? jamMasukAkhir;
  final String? jamPulangAwal;
  final String jamPulang;
  final String? jamPulangAkhir;

  JamShiftModel({
    required this.id,
    required this.name,
    this.jamMasukAwal,
    required this.jamMasuk,
    this.jamMasukAkhir,
    this.jamPulangAwal,
    required this.jamPulang,
    this.jamPulangAkhir,
  });

  factory JamShiftModel.fromJson(Map<String, dynamic> json) {
    return JamShiftModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      jamMasukAwal: json['jam_masuk_awal']?.toString(),
      jamMasuk: json['jam_masuk']?.toString() ?? '',
      jamMasukAkhir: json['jam_masuk_akhir']?.toString(),
      jamPulangAwal: json['jam_pulang_awal']?.toString(),
      jamPulang: json['jam_pulang']?.toString() ?? '',
      jamPulangAkhir: json['jam_pulang_akhir']?.toString(),
    );
  }
}
