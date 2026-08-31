class LiveMapModel {
  final int id;
  final String type;
  final String name;
  final double latitude;
  final double longitude;
  final DateTime? lastSeenAt;

  LiveMapModel({
    required this.id,
    required this.type,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.lastSeenAt,
  });

  factory LiveMapModel.fromJson(Map<String, dynamic> json) {
    return LiveMapModel(
      id: int.tryParse(
            json['id'].toString(),
          ) ??
          0,
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      latitude: double.tryParse(
            json['latitude'].toString(),
          ) ??
          0,
      longitude: double.tryParse(
            json['longitude'].toString(),
          ) ??
          0,
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.tryParse(
              json['last_seen_at'].toString(),
            )
          : null,
    );
  }
}