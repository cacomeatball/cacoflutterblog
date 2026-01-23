import 'dart:io';
import 'dart:typed_data';

import 'package:caco_flutter_blog/core/error/exception.dart';
import 'package:caco_flutter_blog/features/blog/data/models/blog_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<BlogModel> updateBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<String> uploadBlogImageBytes({
    required Uint8List imageBytes,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog(String blogId);
}

class BlogSupabaseSourceImpl implements BlogSupabaseSource {
  final SupabaseClient supabaseClient;
  BlogSupabaseSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = 
        await supabaseClient.from('posts').insert(blog.toJson()).select();
      
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> updateBlog(BlogModel blog) async {
    try {
      final blogData = 
        await supabaseClient.from('posts').update(blog.toJson()).eq('id', blog.id);
      
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String> uploadBlogImage({required File image, required BlogModel blog}) async {
    try {
      // Delete existing image if it exists
      try {
        await supabaseClient.storage.from('blog-images').remove([blog.id]);
      } catch (e) {
        // Image might not exist yet, continue
      }
      
      // Upload new image using uploadBinary for web compatibility
      try {
        final imageBytes = await image.readAsBytes();
        await supabaseClient.storage.from('blog-images').uploadBinary(
          blog.id,
          imageBytes,
        );
      } catch (e) {
        // If File.readAsBytes fails (common on web), try to get bytes directly
        throw ServerException('Failed to read image bytes: $e');
      }

      return supabaseClient.storage.from('blog-images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImageBytes({required Uint8List imageBytes, required BlogModel blog}) async {
    try {
      // Delete existing image if it exists
      try {
        await supabaseClient.storage.from('blog-images').remove([blog.id]);
      } catch (e) {
        // Image might not exist yet, continue
      }
      
      // Upload new image using uploadBinary
      await supabaseClient.storage.from('blog-images').uploadBinary(
        blog.id,
        imageBytes,
      );

      return supabaseClient.storage.from('blog-images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
        .from('posts')
        .select('*, profiles (username)');
      return blogs.map((blog) => BlogModel.fromJson(blog).copyWith(
        username: blog['profiles']['username']
      )).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteBlog(String blogId) async {
    final res = await supabaseClient
      .from('posts')
      .delete()
      .eq('id', blogId);
    if (res.error != null) {
      throw ServerException(res.error!.message);
    }
  }
}
