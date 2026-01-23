import 'dart:io';

import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, Comment>> addComment({
    required String blogId,
    required String userId,
    required String content,
    String? username,
    File? image,
  });

  Future<Either<Failure, List<Comment>>> getCommentsByBlogId(String blogId);

  Future<Either<Failure, void>> deleteComment(String commentId);
}
