part of 'comment_bloc.dart';

abstract class CommentEvent {}

class CommentFetch extends CommentEvent {
  final String blogId;
  CommentFetch({required this.blogId});
}

class CommentAdd extends CommentEvent {
  final String blogId;
  final String userId;
  final String content;
  final String? username;
  final XFile? image;

  CommentAdd({
    required this.blogId,
    required this.userId,
    required this.content,
    this.username,
    this.image,
  });
}

class CommentDeleteEvent extends CommentEvent {
  final String commentId;
  CommentDeleteEvent({required this.commentId});
}

class CommentEditEvent extends CommentEvent {
  final String commentId;
  final String content;
  final XFile? image;
  final bool removeImage;

  CommentEditEvent({
    required this.commentId,
    required this.content,
    this.image,
    this.removeImage = false,
  });
}
