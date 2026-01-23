import 'package:caco_flutter_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:caco_flutter_blog/core/theme/app_palette.dart';
import 'package:caco_flutter_blog/core/utils/format_date.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';
import 'package:caco_flutter_blog/features/blog/presentation/bloc/comment_bloc.dart';
import 'package:caco_flutter_blog/features/blog/presentation/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentListWidget extends StatelessWidget {
  final List<Comment> comments;

  const CommentListWidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No comments yet. Be the first to comment!',
            style: TextStyle(
              color: AppPalette.grayColor,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentTile(comment: comment);
      },
    );
  }
}

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppUserCubit, AppUserState, bool>(
      selector: (userState) {
        if (userState is AppUserLoggedIn) {
          return userState.user.id == comment.userId;
        }
        return false;
      },
      builder: (context, isCommentAuthor) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.username ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatDateBydMMMYYYY(comment.createdAt),
                          style: const TextStyle(
                            color: AppPalette.grayColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (isCommentAuthor)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () async {
                          final confirmed = await showConfirmDialog(
                            context: context,
                            title: 'Delete Comment',
                            content: 'Are you sure you want to delete this comment?',
                            confirmText: 'Delete',
                          );
                          if (!confirmed) return;
                          if (context.mounted) {
                            context.read<CommentBloc>().add(
                              CommentDeleteEvent(commentId: comment.id),
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                if (comment.imageUrl != null) ...[
                  const SizedBox(height: 12.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      comment.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
