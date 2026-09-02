class LokasiKunjunganModel {
  final int id;
  final String namaLokasi;
  final String? qrcode;
  final String? latitude;
  final String? longitude;
  final int jumlahKunjungan;

  LokasiKunjunganModel({
    required this.id,
    required this.namaLokasi,
    this.qrcode,
    this.latitude,
    this.longitude,
    required this.jumlahKunjungan,
  });

  factory LokasiKunjunganModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LokasiKunjunganModel(
      id: int.tryParse(
            json['id'].toString(),
          ) ??
          0,

      namaLokasi:
          json['nama_lokasi']?.toString() ?? '',

      qrcode:
          json['qrcode']?.toString(),

      latitude:
          json['latitude']?.toString(),

      longitude:
          json['longitude']?.toString(),

      jumlahKunjungan: int.tryParse(
            json['jumlah_kunjungan'].toString(),
          ) ??
          0,
    );
  }
}