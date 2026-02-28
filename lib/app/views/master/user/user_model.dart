class UserModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final int isActive;
  final int comid;
  final String comName;
  final String whatsapp;
  final String level;
  final int isArea;
  final String? profileImage;
  final int isMobileAdmin;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isActive,
    required this.comid,
    required this.comName,
    required this.whatsapp,
    required this.level,
    required this.isArea,
    this.profileImage,
    required this.isMobileAdmin,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      isActive: json['is_active'] ?? 0,
      comid: json['company_id'] ?? '0',
      comName: json['company']['company_name'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      level: json['level'] ?? '',
      isArea: json['is_area'] ?? 0,
      profileImage: json['profile_image'] ?? '',
      isMobileAdmin: json['is_mobile_admin'] ?? 0,
      createdAt: json['created_at'],
    );
  }
}
