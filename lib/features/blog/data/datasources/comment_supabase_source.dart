import 'package:image_picker/image_picker.dart';

import 'package:caco_flutter_blog/core/error/exception.dart';
import 'package:caco_flutter_blog/features/blog/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CommentSupabaseSource {
  Future<CommentModel> addComment(CommentModel comment);
  Future<List<CommentModel>> getCommentsByBlogId(String blogId);
  Future<void> deleteComment(String commentId);
  Future<String?> uploadCommentImage({
    XFile? image,
    required String commentId,
  });
  Future<CommentModel> updateComment({
    required String commentId,
    required String content,
    String? imageUrl,
    bool removeImage = false,
  });
}

class CommentSupabaseSourceImpl implements CommentSupabaseSource {
  final SupabaseClient supabaseClient;
  CommentSupabaseSourceImpl(this.supabaseClient);

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    try {
      final commentData = await supabaseClient
          .from('comments')
          .insert(comment.toJson())
          .select();

      return CommentModel.fromJson(commentData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CommentModel>> getCommentsByBlogId(String blogId) async {
    try {
      final commentsData = await supabaseClient
          .from('comments')
          .select()
          .eq('post_id', blogId)
          .order('created_at', ascending: false);

      return List<CommentModel>.from(
        (commentsData as List<dynamic>).map<CommentModel>(
          (x) => CommentModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await supabaseClient.from('comments').delete().eq('id', commentId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> uploadCommentImage({
    XFile? image,
    required String commentId,
  }) async {
    try {
      // Return null if no image is provided
      if (image == null) {
        return null;
      }
      
      final imageBytes = await image.readAsBytes();
      
      // Create a unique filename to avoid conflicts and enable upsert
      final filename = 'comment_${commentId}_${DateTime.now().millisecondsSinceEpoch}';

      await supabaseClient.storage
          .from('comment-images')
          .uploadBinary(
            filename,
            imageBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabaseClient.storage
          .from('comment-images')
          .getPublicUrl(filename);

      return publicUrl;
    } on StorageException catch (e) {
      throw ServerException('Storage error: ${e.message}');
    } catch (e) {
      throw ServerException('Image upload failed: ${e.toString()}');
    }
  }

  @override
  Future<CommentModel> updateComment({
    required String commentId,
    required String content,
    String? imageUrl,
    bool removeImage = false,
  }) async {
    try {
      final updateData = {
        'content': content,
        if (imageUrl != null) 'image_url': imageUrl,
        if (removeImage) 'image_url': null,
      };

      final commentData = await supabaseClient
          .from('comments')
          .update(updateData)
          .eq('id', commentId)
          .select();

      return CommentModel.fromJson(commentData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
