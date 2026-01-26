class RuteModel {
  final int id;
  final String jamMasuk;
  final String jamPulang;
  final int satpamId;
  final String satpamName;
  final int comid;
  final String comName;

  RuteModel({
    required this.id,
    required this.jamMasuk,
    required this.jamPulang,
    required this.satpamId,
    required this.satpamName,
    required this.comid,
    required this.comName,
  });

  factory RuteModel.fromJson(Map<String, dynamic> json) {
    return RuteModel(
      id: json['id'],
      jamMasuk: json['jam_masuk'],
      jamPulang: json['jam_keluar'] ?? '',
      satpamId: json['satpam_id'],
      satpamName: json['satpam']['name'] ?? '',
      comid: json['comid'],
      comName: json['company']['company_name'] ?? '',
    );
  }
}
