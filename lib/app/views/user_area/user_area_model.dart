class UserAreaModel {
  final int id;
  final int monitoringComId;
  final String monitoringComName;

  UserAreaModel({
    required this.id,
    required this.monitoringComId,
    required this.monitoringComName,
  });

  factory UserAreaModel.fromJson(Map<String, dynamic> json) {
    return UserAreaModel(
      id: json['id'],
      monitoringComId: json['monitoring_comid'],
      monitoringComName: json['company_monitoring']['company_name'] ?? '',
    );
  }
}
