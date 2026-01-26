import 'package:caco_flutter_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:caco_flutter_blog/core/theme/app_palette.dart';
import 'package:caco_flutter_blog/core/utils/format_date.dart';
import 'package:caco_flutter_blog/core/utils/show_snackbar.dart';
import 'package:caco_flutter_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caco_flutter_blog/features/blog/domain/entities/blog.dart';
import 'package:caco_flutter_blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:caco_flutter_blog/features/blog/presentation/bloc/comment_bloc.dart';
import 'package:caco_flutter_blog/features/blog/presentation/pages/blog_page.dart';
import 'package:caco_flutter_blog/features/blog/presentation/widgets/comment_input_widget.dart';
import 'package:caco_flutter_blog/features/blog/presentation/widgets/comment_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  bool _navigatedAway = false;
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    context.read<CommentBloc>().add(CommentFetch(blogId: widget.blog.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (_navigatedAway) return;
        if (state is BlogDeleteSuccess) {
          _navigatedAway = true;
          showSnackBar(context, 'Blog deleted!');
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
        }
      },
      child: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
          appBar: AppBar(),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'by ${widget.blog.username!}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatDateBydMMMYYYY(widget.blog.created_at),
                      style: const TextStyle(
                        color: AppPalette.grayColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.blog.image_url),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.blog.content,
                      style: const TextStyle(fontSize: 16, height: 2),
                    ),
                    const Divider(height: 40),
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CommentInputWidget(blogId: widget.blog.id),
                    const SizedBox(height: 20),
                    BlocBuilder<CommentBloc, CommentState>(
                      builder: (context, state) {
                        if (state is CommentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CommentLoaded) {
                          return CommentListWidget(comments: state.comments);
                        } else if (state is CommentFailure) {
                          return Center(
                            child: Text(state.error),
                          );
                        }
                        return CommentListWidget(comments: const []);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
