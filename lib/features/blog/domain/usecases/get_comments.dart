import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/comment_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetComments implements UseCase<List<Comment>, GetCommentsParams> {
  final CommentRepository commentRepository;
  GetComments(this.commentRepository);

  @override
  Future<Either<Failure, List<Comment>>> call(GetCommentsParams params) async {
    return await commentRepository.getCommentsByBlogId(params.blogId);
  }
}

class GetCommentsParams {
  final String blogId;

  GetCommentsParams({required this.blogId});
}
