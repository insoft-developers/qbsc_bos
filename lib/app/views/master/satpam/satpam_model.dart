class SatpamModel {
  final int id;
  final String name;
  final String? badgeId;
  final String whatsapp;
  final String? password;
  final int comid;
  final String comName;
  final String? foto;
  final bool isActive;
  final bool isDanru;
  final String? lastLatitude;
  final String? lastLongitude;
  final String? lastSeenAt;
  final String createdAt;

  SatpamModel({
    required this.id,
    required this.name,
    this.badgeId,
    required this.whatsapp,
    this.password,
    required this.comid,
    required this.comName,
    this.foto,
    required this.isActive,
    required this.isDanru,
    this.lastLatitude,
    this.lastLongitude,
    this.lastSeenAt,
    required this.createdAt,
  });

  factory SatpamModel.fromJson(Map<String, dynamic> json) {
    return SatpamModel(
      id: json['id'],
      name: json['name'],
      badgeId: json['badge_id'],
      whatsapp: json['whatsapp'],
      password: json['password'] ?? '',
      comid: json['comid'],
      comName: json['company']['company_name'] ?? '',
      foto: json['face_photo_path'] ?? '',
      isActive: json['is_active'] == 1 ? true : false,
      isDanru: json['is_danru'] == 1 ? true : false,
      lastLatitude: json['last_latitude'] ?? '',
      lastLongitude: json['last_longitude'] ?? '',
      lastSeenAt: json['last_seen_at'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
