import 'dart:typed_data';

import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required Uint8List imageBytes,
    required String title,
    required String content,
    required String user_id,
  });

  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    required Uint8List? imageBytes,
    required String title,
    required String content,
    required String user_id,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();

  Future<Either<Failure, void>> deleteBlog(String blogId);
}