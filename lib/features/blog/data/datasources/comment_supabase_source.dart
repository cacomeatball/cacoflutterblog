import 'dart:io';

import 'package:caco_flutter_blog/core/error/exception.dart';
import 'package:caco_flutter_blog/features/blog/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CommentSupabaseSource {
  Future<CommentModel> addComment(CommentModel comment);
  Future<List<CommentModel>> getCommentsByBlogId(String blogId);
  Future<void> deleteComment(String commentId);
  Future<String> uploadCommentImage({
    required File image,
    required String commentId,
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
  Future<String> uploadCommentImage({
    required File image,
    required String commentId,
  }) async {
    try {
      final imagePath = 'comment_$commentId';

      // Delete existing image if it exists
      try {
        await supabaseClient.storage.from('comment-images').remove([imagePath]);
      } catch (e) {
        // Image might not exist yet, continue
      }

      // Upload using uploadBinary for web compatibility
      final imageBytes = await image.readAsBytes();
      await supabaseClient.storage
          .from('comment-images')
          .uploadBinary(imagePath, imageBytes);

      final publicUrl = supabaseClient.storage
          .from('comment-images')
          .getPublicUrl(imagePath);

      return publicUrl;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
