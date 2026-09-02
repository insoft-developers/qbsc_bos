class BlogModel {
  final int id;
  final String title;
  final String? slug;
  final String? content;
  final String? image;
  final int? createdBy;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    this.slug,
    this.content,
    this.image,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'],
      content: json['content'],
      image: json['image'],
      createdBy: json['created_by'],
      isActive: json['is_active'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}