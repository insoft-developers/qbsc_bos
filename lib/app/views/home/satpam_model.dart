class SatpamModel {
  final int id;
  final String name;
  final String? badgeId;
  final String whatsapp;
  final int comid;
  final String comName;
  final String? foto;
  final int isActive;

  SatpamModel({
    required this.id,
    required this.name,
    this.badgeId,
    required this.whatsapp,
    required this.comid,
    required this.comName,
    this.foto,
    required this.isActive,
  });

  factory SatpamModel.fromJson(Map<String, dynamic> json) {
    return SatpamModel(
      id: json['id'],
      name: json['name'] ?? '',
      badgeId: json['badge_id'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      comid: json['comid'],
      comName: json['company']['name'] ?? '',
      foto: json['face_photo_path'] ?? '',
      isActive: json['is_active'] ?? 0,
    );
  }
}
