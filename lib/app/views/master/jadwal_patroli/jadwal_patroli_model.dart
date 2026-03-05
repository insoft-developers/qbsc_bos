class JadwalPatroliModel {
  final int id;
  final String name;
  final String description;
  final int isActive;
  final int comid;
  final String comName;

  JadwalPatroliModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.comid,
    required this.comName,
  });

  factory JadwalPatroliModel.fromJson(Map<String, dynamic> json) {
    return JadwalPatroliModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? 0,
      comid: json['comid'] ?? 0,
      comName: json['company']['company_name'] ?? '',
    );
  }
}
