import 'package:caco_flutter_blog/features/blog/presentation/pages/write_new_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cacocacoblog!'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, WriteNewBlog.route());
            }, 
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to cacocacoblog!'),
      ),
    );
  }
}