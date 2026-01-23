import 'dart:typed_data';

import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements UseCase<Blog, UpdateBlogParams> {
  final BlogRepository blogRepository;
  UpdateBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UpdateBlogParams params) async {
    return await blogRepository.updateBlog(
      blogId: params.blogId,
      imageBytes: params.imageBytes, 
      title: params.title, 
      content: params.content, 
      user_id: params.user_id, 
    );
  }

}

class UpdateBlogParams {
  final String blogId;
  final String user_id;
  final String title;
  final String content;
  final Uint8List? imageBytes;


  UpdateBlogParams({
    required this.blogId,
    required this.user_id, 
    required this.title,
    required this.content, 
    required this.imageBytes, 

  });
}