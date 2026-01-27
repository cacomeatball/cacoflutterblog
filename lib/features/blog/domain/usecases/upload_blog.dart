import 'package:image_picker/image_picker.dart';

import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image, 
      title: params.title, 
      content: params.content, 
      user_id: params.user_id, 
    );
  }

}

class UploadBlogParams {
  final String user_id;
  final String title;
  final String content;
  final XFile? image;


  UploadBlogParams({
    required this.user_id, 
    required this.title,
    required this.content, 
    this.image, 

  });
}