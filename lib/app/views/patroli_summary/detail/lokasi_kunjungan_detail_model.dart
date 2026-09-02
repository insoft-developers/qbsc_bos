class LokasiKunjunganDetailModel {
  final int id;
  final String tanggal;
  final String jam;
  final int satpamId;
  final String namaSatpam;
  final String? note;
  final String? photoPath;

  LokasiKunjunganDetailModel({
    required this.id,
    required this.tanggal,
    required this.jam,
    required this.satpamId,
    required this.namaSatpam,
    this.note,
    this.photoPath,
  });

  factory LokasiKunjunganDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LokasiKunjunganDetailModel(
      id: json['id'] ?? 0,
      tanggal: json['tanggal'] ?? '',
      jam: json['jam'] ?? '',
      satpamId: json['satpam_id'] ?? 0,
      namaSatpam: json['nama_satpam'] ?? '-',
      note: json['note'],
      photoPath: json['photo_path'],
    );
  }
}