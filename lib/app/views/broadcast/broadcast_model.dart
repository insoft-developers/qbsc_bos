class BroadcastModel {
  final int id;
  final String judul;
  final String pesan;
  final String? image;
  final int pengirim;
  final int sendStatus;
  final int comid;
  final String createdAt;

  BroadcastModel({
    required this.id,
    required this.judul,
    required this.pesan,
    this.image,
    required this.pengirim,
    required this.sendStatus,
    required this.comid,
    required this.createdAt,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'],
      judul: json['judul'],
      pesan: json['pesan'],
      image: json['image'],
      pengirim: json['pengirim'],
      sendStatus: json['send_status'],
      comid: json['comid'],
      createdAt: json['created_at'],
    );
  }
}
