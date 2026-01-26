class TrackingMapModel {
  final double lat;
  final double lng;
  final String keterangan;
  final String tanggal;
  final String satpam;

  TrackingMapModel({
    required this.lat,
    required this.lng,
    required this.keterangan,
    required this.tanggal,
    required this.satpam,
  });

  factory TrackingMapModel.fromJson(Map<String, dynamic> json) {
    return TrackingMapModel(
      lat: double.parse(json['latitude'].toString()),
      lng: double.parse(json['longitude'].toString()),
      keterangan: json['keterangan'],
      tanggal: json['tanggal'],
      satpam: json['satpam_name'],
    );
  }
}
