class SliderImageModel {
  final String image;

  SliderImageModel({required this.image});

  factory SliderImageModel.fromJson(Map<String, dynamic> json) {
    return SliderImageModel(image: json['image'] ?? '');
  }
}
