import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Cross-platform image display widget that works on web and mobile
class CrossPlatformImage extends StatefulWidget {
  final File? file;
  final XFile? xfile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CrossPlatformImage({
    Key? key,
    this.file,
    this.xfile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<CrossPlatformImage> createState() => _CrossPlatformImageState();
}

class _CrossPlatformImageState extends State<CrossPlatformImage> {
  late Future<Uint8List?> imageBytes;

  @override
  void initState() {
    super.initState();
    imageBytes = _getImageBytes();
  }

  Future<Uint8List?> _getImageBytes() async {
    try {
      if (widget.file != null) {
        return await widget.file!.readAsBytes();
      } else if (widget.xfile != null) {
        return await widget.xfile!.readAsBytes();
      }
    } catch (e) {
      debugPrint('Error reading image bytes: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: imageBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Image error: ${snapshot.error}');
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading image',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.data == null) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_not_supported, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'No image selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        Widget imageWidget = Image.memory(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );

        if (widget.borderRadius != null) {
          imageWidget = ClipRRect(
            borderRadius: widget.borderRadius!,
            child: imageWidget,
          );
        }

        return imageWidget;
      },
    );
  }
}
