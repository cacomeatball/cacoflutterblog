import 'package:image_picker/image_picker.dart';

import 'package:caco_flutter_blog/core/error/exception.dart';
import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/features/blog/data/datasources/blog_supabase_source.dart';
import 'package:caco_flutter_blog/features/blog/data/models/blog_model.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';
import 'package:caco_flutter_blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogSupabaseSource blogSupabaseSource;
  BlogRepositoryImpl(this.blogSupabaseSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required XFile? image, 
    required String title, 
    required String content, 
    required String user_id,
    }) async {
      try {
        var imageUrl = '';
        
        // Only upload image if provided
        if (image != null) {
          BlogModel tempBlogModel = BlogModel(
            id: const Uuid().v1(), 
            user_id: user_id, 
            title: title, 
            content: content,
            image_url: '', 
            username: '',
            created_at: DateTime.now(),  
          );
          final uploadedImageUrl = await blogSupabaseSource.uploadBlogImage(
            image: image, 
            blog: tempBlogModel
          );
          imageUrl = uploadedImageUrl ?? '';
        }
        
        BlogModel blogModel = BlogModel(
          id: const Uuid().v1(), 
          user_id: user_id, 
          title: title, 
          content: content,
          image_url: imageUrl, 
          username: '',
          created_at: DateTime.now(),  
        );
        final uploadedBlog = await blogSupabaseSource.uploadBlog(blogModel);
        return Right(uploadedBlog);
      } on ServerException catch (e) {
        return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    required XFile? image, 
    required String title, 
    required String content, 
    required String user_id,
    required bool removeImage,
    }) async {
      try {
        // Fetch the existing blog to preserve data if not being updated
        final existingBlogs = await blogSupabaseSource.getAllBlogs();
        final existingBlog = existingBlogs.firstWhere(
          (blog) => blog.id == blogId,
          orElse: () => BlogModel(
            id: blogId,
            user_id: user_id,
            title: title,
            content: content,
            image_url: '',
            username: '',
            created_at: DateTime.now(),
          ),
        );
        
        var imageUrl = existingBlog.image_url; // Preserve existing image URL by default
        
        // Handle image removal
        if (removeImage) {
          imageUrl = '';
        }
        // Only upload new image if provided
        else if (image != null) {
          final uploadedUrl = await blogSupabaseSource.uploadBlogImage(
            image: image,
            blog: BlogModel(
              id: blogId,
              user_id: user_id,
              title: title,
              content: content,
              image_url: '',
              username: '',
              created_at: existingBlog.created_at,
            ),
          );
          imageUrl = uploadedUrl ?? existingBlog.image_url;
        }
        
        BlogModel blogModel = BlogModel(
          id: blogId, 
          user_id: user_id, 
          title: title, 
          content: content,
          image_url: imageUrl, 
          username: existingBlog.username,
          created_at: existingBlog.created_at,  
        );
        final updatedBlog = await blogSupabaseSource.updateBlog(blogModel);
        return Right(updatedBlog);
      } on ServerException catch (e) {
        return Left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogSupabaseSource.getAllBlogs();
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteBlog(String blogId) async {
    try {
      await blogSupabaseSource.deleteBlog(blogId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}