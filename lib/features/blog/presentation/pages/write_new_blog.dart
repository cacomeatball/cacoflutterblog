import 'package:caco_flutter_blog/core/theme/app_palette.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class WriteNewBlog extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const WriteNewBlog(),
  );
  const WriteNewBlog({super.key});

  @override
  State<WriteNewBlog> createState() => _WriteNewBlogState();
}

class _WriteNewBlogState extends State<WriteNewBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.done_rounded),
          ),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DottedBorder(
              options: RectDottedBorderOptions(
                color: AppPalette.primaryColor,
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
              ),
              child: Container(
                height: 150,
                width: double.infinity,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 40,
                      ),
                    SizedBox(height: 15),
                    Text(
                      'Upload Cover Image',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}