import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json['id'] as String,
    posterId: json['poster_id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    imageUrl: json['image_url'] as String,
    topics: (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'poster_id': posterId,
    'title': title,
    'content': content,
    'image_url': imageUrl,
    'topics': topics,
    'updated_at': updatedAt.toIso8601String(),
  };
}
