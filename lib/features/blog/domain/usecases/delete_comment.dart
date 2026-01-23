import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/comment_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteComment implements UseCase<void, DeleteCommentParams> {
  final CommentRepository commentRepository;
  DeleteComment(this.commentRepository);

  @override
  Future<Either<Failure, void>> call(DeleteCommentParams params) async {
    return await commentRepository.deleteComment(params.commentId);
  }
}

class DeleteCommentParams {
  final String commentId;

  DeleteCommentParams({required this.commentId});
}
