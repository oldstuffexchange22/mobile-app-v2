import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<Image> images = [];
  @override
  void initState() {
    getImages();
    super.initState();
  }

  Future<void> getImages() async {
    final _storage = FirebaseStorage.instance;
    ListResult result = await _storage
        .ref()
        .child('posts')
        .child('30363c00-fb32-11ec-a7b5-6771bb157541')
        .listAll();
    result.items.forEach((element) async {
      String downloadLink = await element.getDownloadURL();
      final image = Image.network(
        downloadLink,
        height: 100,
      );
      images.add(image);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: CarouselSlider(
            items: images.map((e) => e).toList(),
            options: CarouselOptions(height: 300)));
  }
}
