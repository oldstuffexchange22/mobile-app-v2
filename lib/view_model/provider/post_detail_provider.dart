import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PostDetailProvider with ChangeNotifier {
  late List<XFile> _images;
  get images => _images;
}
