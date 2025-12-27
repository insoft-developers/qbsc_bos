class NotifikasiModel {
  final int id;
  final String pengirim;
  final String judul;
  final String pesan;
  final String? image;
  final String? isRead;
  final int comid;
  final String createdAt;

  NotifikasiModel({
    required this.id,
    required this.pengirim,
    required this.judul,
    required this.pesan,
    this.image,
    this.isRead,
    required this.comid,
    required this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'] ?? 0,
      pengirim: json['pengirim'] ?? '',
      judul: json['judul'] ?? '',
      pesan: json['pesan'] ?? '',
      image: json['image'] ?? '',
      isRead: json['is_read']?.toString(),
      comid: json['comid'] ?? 0,

      createdAt: json['created_at'] ?? '',
    );
  }
}
