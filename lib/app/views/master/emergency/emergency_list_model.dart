class EmergencyListModel {
  final int id;
  final String name;
  final String whatsapp;
  final int comid;

  EmergencyListModel({
    required this.id,
    required this.name,
    required this.whatsapp,
    required this.comid,
  });

  factory EmergencyListModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmergencyListModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,
      name: json['name']?.toString() ?? '',
      whatsapp:
          json['whatsapp']?.toString() ?? '',
      comid: int.tryParse(
            json['comid']?.toString() ?? '0',
          ) ??
          0,
    );
  }
}