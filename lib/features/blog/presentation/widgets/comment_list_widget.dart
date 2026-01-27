import 'package:caco_flutter_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:caco_flutter_blog/core/theme/app_palette.dart';
import 'package:caco_flutter_blog/core/utils/format_date.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/comment.dart';
import 'package:caco_flutter_blog/features/blog/presentation/bloc/comment_bloc.dart';
import 'package:caco_flutter_blog/features/blog/presentation/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                            onPressed: () async {
                              final editedComment = await _showEditCommentDialog(
                                context: context,
                                comment: comment,
                              );
                              if (editedComment != null && context.mounted) {
                                context.read<CommentBloc>().add(
                                  CommentEditEvent(
                                    commentId: comment.id,
                                    content: editedComment['content'],
                                    image: editedComment['image'],
                                    removeImage: editedComment['removeImage'] ?? false,
                                  ),
                                );
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
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
                      )
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

  Future<Map<String, dynamic>?> _showEditCommentDialog({
    required BuildContext context,
    required Comment comment,
  }) async {
    final contentController = TextEditingController(text: comment.content);
    XFile? selectedImage;
    bool removeImage = false;

    return await showDialog<Map<String, dynamic>?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Comment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: 'Edit your comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                  const SizedBox(height: 20),
                  if (comment.imageUrl != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current image:',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Image attached',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: removeImage ? Colors.grey : Colors.black87,
                                    decoration: removeImage ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                removeImage ? Icons.restore : Icons.delete,
                                color: removeImage ? Colors.orange : Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  removeImage = !removeImage;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: removeImage ? 'Keep image' : 'Remove image',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  if (selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'New image: ${selectedImage!.name}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image, size: 18),
                    label: Text(selectedImage != null ? 'Change Image' : 'Add Image'),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 75,
                      );
                      if (image != null && context.mounted) {
                        setState(() {
                          selectedImage = image;
                          removeImage = false;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                    contentController.dispose();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (contentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment cannot be empty')),
                      );
                      return;
                    }
                    Navigator.of(context).pop({
                      'content': contentController.text.trim(),
                      'image': selectedImage,
                      'removeImage': removeImage,
                    });
                    contentController.dispose();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
