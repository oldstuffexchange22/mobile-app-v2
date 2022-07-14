import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/category.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/request/post_create.dart';
import 'package:old_stuff_exchange/model/request/product_create.dart';
import 'package:old_stuff_exchange/repository/implement/category_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';
import 'package:uuid/uuid.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PostProvider with ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();

  List<CreateProduct> products = [];
  Post? _newPost;
  List<Category> categories = [];
  String _categoryValue = '';

  get categoryValue => _categoryValue;
  set setCategoryValue(String value) {
    _categoryValue = value;
  }

  void createProduct(CreateProduct product) {
    products.add(product);
  }

  void notify() {
    notifyListeners();
  }

  void deleteProduct(int index) {
    products.removeAt(index);
    notifyListeners();
  }

  Future<void> createPost(BuildContext context, String title,
      String description, List<XFile>? images, String userId) async {
    try {
      context.loaderOverlay.show(
          widget: const CustomOverlay(
        content: 'Đang tạo bài đăng',
      ));
      final _storage = FirebaseStorage.instance;
      String postId = const Uuid().v1();
      List<String> imagesUrl = [];
      // apply post id to list product
      products = products.map(
        (e) {
          e.postId = postId;
          return e;
        },
      ).toList();
      for (var element in images!) {
        var file = File(element.path);
        var fileName = element.path.substring(element.path.lastIndexOf('/'));
        var snapshot =
            await _storage.ref().child('posts/$postId/$fileName').putFile(file);
        // ListResult result =
        //     await _storage.ref().child('posts').child(postId).listAll();
        // result.items.forEach((element) async {
        //   String downloadLink = await element.getDownloadURL();
        //   print(downloadLink);
        // });
        String downloadLink = await snapshot.ref.getDownloadURL();
        imagesUrl.add(downloadLink);
      }
      String imageUrl = imagesUrl[0];
      CreatePost newPost = CreatePost(
          id: postId,
          title: title,
          description: description,
          imageUrl: imageUrl,
          authorId: userId,
          products: products);
      Post? post = await PostRepImp().create(newPost);
      if (post == null) {
        showToastFail('Create post fail');
        context.loaderOverlay.hide();
        return;
      }
      clearAllData();
      notifyListeners();
      context.loaderOverlay.hide();
    } catch (e) {
      context.loaderOverlay.hide();
      showToastFail('Create product fail');
    }
  }

  void getCategories() async {
    categories = await CategoryReqImp().getAll();
    _categoryValue = categories[0].id;
    notifyListeners();
  }

  void clearAllData() async {
    _newPost = null;
    products = [];
    getCategories();
  }
}
