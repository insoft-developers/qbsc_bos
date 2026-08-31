class SliderModel {
  final String image;
  final String title;
  final String subtitle;
  final String content;

  SliderModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}
