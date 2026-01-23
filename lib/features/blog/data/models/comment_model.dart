import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.blogId,
    required super.userId,
    required super.content,
    required super.createdAt,
    super.username,
    super.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'post_id': blogId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'username': username,
      'image_url': imageUrl,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      blogId: map['post_id'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      username: map['username'] as String?,
      imageUrl: map['image_url'] as String?,
    );
  }

  CommentModel copyWith({
    String? id,
    String? blogId,
    String? userId,
    String? content,
    DateTime? createdAt,
    String? username,
    String? imageUrl,
  }) {
    return CommentModel(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
