part of 'comment_bloc.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  CommentLoaded(this.comments);
}

class CommentAdded extends CommentState {
  final Comment comment;
  CommentAdded(this.comment);
}

class CommentDeleted extends CommentState {}

class CommentFailure extends CommentState {
  final String error;
  CommentFailure(this.error);
}
