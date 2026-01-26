import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  try {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    return file;
  } catch (e) {
    return null;
  }
}