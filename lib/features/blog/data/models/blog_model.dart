import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.user_id,
    required super.created_at, 
    required super.title, 
    required super.content,  
    required super.image_url,
    super.username,
    }
  );
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'created_at': created_at.toIso8601String(),
      'title': title,
      'content': content,
      //'username': username,
      'image_url': image_url,
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      user_id: map['user_id'] as String,
      created_at: map['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(map['created_at']),
      title: map['title'] as String,
      content: map['content'] as String,
      //username: map['username'] as String,
      image_url: map['image_url'] as String,
    );
  }

  BlogModel copyWith({
    String? id,
    String? user_id,
    String? title,
    String? content,
    String? username,
    String? image_url,
    DateTime? created_at,
  }) {
    return BlogModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      content: content ?? this.content,
      username: username ?? this.username,
      image_url: image_url ?? this.image_url, 
      created_at: created_at ?? this.created_at,
    );
  }

}