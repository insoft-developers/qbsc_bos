class DocModel {
  final int id;
  final String tanggal;
  final String? inputDate;
  final String jam;
  final int satpamId;
  final String satpamName;
  final int jumlah;
  final int ekspedisiId;
  final String ekspedisiName;
  final String? tujuan;
  final String? noPolisi;
  final int jenis;
  final String? note;
  final String? foto;
  final int comid;
  final String comName;
  final String createdAt;

  DocModel({
    required this.id,
    required this.tanggal,
    this.inputDate,
    required this.jam,
    required this.satpamId,
    required this.satpamName,
    required this.jumlah,
    required this.ekspedisiId,
    required this.ekspedisiName,
    this.tujuan,
    this.noPolisi,
    required this.jenis,
    this.note,
    this.foto,
    required this.comid,
    required this.comName,
    required this.createdAt,
  });

  factory DocModel.fromJson(Map<String, dynamic> json) {
    return DocModel(
      id: json['id'],
      tanggal: json['tanggal'],
      inputDate: json['input_date'],
      jam: json['jam'],
      satpamId: json['satpam_id'],
      satpamName: json['satpam']['name'] ?? '',
      jumlah: json['jumlah'],
      ekspedisiId: json['ekspedisi_id'],
      ekspedisiName: json['ekspedisi']['name'] ?? '',
      tujuan: json['tujuan'],
      noPolisi: json['no_polisi'],
      jenis: json['jenis'],
      note: json['note'] ?? '',
      foto: json['foto'] ?? '',
      comid: json['comid'],
      comName: json['company']['company_name'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
