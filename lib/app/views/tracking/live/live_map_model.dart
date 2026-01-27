class LiveMapModel {
  final int id;
  final String type; // 'satpam' | 'patroli'
  final String name;
  final double latitude;
  final double longitude;

  LiveMapModel({
    required this.id,
    required this.type,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LiveMapModel.fromJson(Map<String, dynamic> json) {
    return LiveMapModel(
      id: json['id'],
      type: json['type'], // 🔥 penting
      name: json['name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}
