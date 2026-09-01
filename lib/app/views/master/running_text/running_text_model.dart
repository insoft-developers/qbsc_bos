class RunningTextModel {
  final int id;
  final String text;
  final int comid;

  RunningTextModel({
    required this.id,
    required this.text,
    required this.comid,
  });

  factory RunningTextModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RunningTextModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,
      text: json['text']?.toString() ?? '',
      comid: int.tryParse(
            json['comid']?.toString() ?? '0',
          ) ??
          0,
    );
  }
}