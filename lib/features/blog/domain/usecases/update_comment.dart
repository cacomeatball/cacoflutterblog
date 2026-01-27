import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/comment_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

class UpdateComment implements UseCase<Comment, UpdateCommentParams> {
  final CommentRepository commentRepository;
  UpdateComment(this.commentRepository);

  @override
  Future<Either<Failure, Comment>> call(UpdateCommentParams params) async {
    return await commentRepository.updateComment(
      commentId: params.commentId,
      content: params.content,
      image: params.image,
    );
  }
}

class UpdateCommentParams {
  final String commentId;
  final String content;
  final XFile? image;
  final bool removeImage;

  UpdateCommentParams({
    required this.commentId,
    required this.content,
    this.image,
    this.removeImage = false,
  });
}
