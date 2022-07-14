import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/view_model/provider/post_payment_provider.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<Image> images = [];
  List<String> imagesString = [];
  int _currentImage = 0;
  final CarouselController _imageController = CarouselController();
  @override
  void initState() {
    getImages();
    super.initState();
  }

  Future<void> getImages() async {
    final storage = FirebaseStorage.instance;
    SecureStorage secureStorage = SecureStorage();
    String token = await secureStorage.readSecureData('token');
    Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
    String userId = widget.post.authorId;
    ListResult result =
        await storage.ref().child('posts').child(widget.post.id).listAll();
    result.items.forEach((element) async {
      String downloadLink = await element.getDownloadURL();
      final image = Image.network(
        downloadLink,
      );
      images.add(image);
      imagesString.add(downloadLink);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    PostPaymentProvider postPaymentProvider =
        Provider.of<PostPaymentProvider>(context);
    postPaymentProvider.setCurrentPost = widget.post;

    Size screenSize = MediaQuery.of(context).size;
    List<Product> products = widget.post.products;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          _headerSlider(screenSize, context),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.title,
                  style: PrimaryFont.semiBold(16),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '${widget.post.price}00 VND',
                  style: PrimaryFont.semiBold(20).copyWith(color: Colors.red),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Tòa nhà : ${widget.post.author?.building?.name}',
                  style: PrimaryFont.light(18),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text('Danh sách sản phẩm : ',
                    style: PrimaryFont.extraLight(18)),
                const SizedBox(
                  height: 8,
                ),
                _listProduct(products),
                const SizedBox(
                  height: 8,
                ),
                Text('Miêu tả : ', style: PrimaryFont.extraLight(18)),
                Text(
                  widget.post.description,
                  style: PrimaryFont.regular(18),
                ),
                const Divider(
                  height: 28,
                  thickness: 0.4,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromARGB(255, 202, 194, 194),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.post.author?.fullName ?? '',
                      style: PrimaryFont.extraLight(22),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Liên hệ ngay : ${widget.post.author?.phone}',
                  style: PrimaryFont.extraLight(14).copyWith(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
                const Divider(
                  height: 28,
                  thickness: 0.4,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromARGB(255, 202, 194, 194),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          )
        ]),
      ),
      floatingActionButton: SizedBox(
        width: screenSize.width,
        child: FloatingActionButton(
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          onPressed: () {
            Navigator.of(context).pushNamed('/paymentPostPage');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.payment),
              const SizedBox(
                width: 12,
              ),
              Text(
                'Mua',
                style: PrimaryFont.extraLight(20).copyWith(color: kColorWhite),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Container _listProduct(List<Product> products) {
    return Container(
      color: Colors.transparent.withOpacity(0.08),
      height: 50 * products.length.toDouble(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
            itemBuilder: (context, index) {
              Product product = products[index];
              return SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(flex: 2, child: _productField(product.name)),
                      Flexible(
                          flex: 2, child: _productField('${product.price}00')),
                      Flexible(
                          flex: 5, child: _productField(product.description)),
                    ]),
              );
            },
            itemCount: products.length),
      ),
    );
  }

  Padding _productField(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        showDuration: const Duration(seconds: 1),
        message: content,
        child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: PrimaryFont.regular(16),
        ),
      ),
    );
  }

  Stack _headerSlider(Size screenSize, BuildContext context) {
    return Stack(children: [
      CarouselSlider(
          carouselController: _imageController,
          items: images
              .map((e) => SizedBox(
                  width: screenSize.width,
                  height: 200,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: e,
                  )))
              .toList(),
          options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImage = index;
                });
              })),
      Positioned(
        bottom: 12,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagesString.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _imageController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_currentImage == entry.key ? 0.9 : 0.3)),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
