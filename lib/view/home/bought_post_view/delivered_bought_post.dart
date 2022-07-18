import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_bought_provider.dart';
import 'package:old_stuff_exchange/widgets/center_refresh/center_refresh.dart';
import 'package:provider/provider.dart';

class DeliveredBoughtPost extends StatefulWidget {
  const DeliveredBoughtPost({Key? key}) : super(key: key);

  @override
  State<DeliveredBoughtPost> createState() => _DeliveredBoughtPostState();
}

class _DeliveredBoughtPostState extends State<DeliveredBoughtPost> {
  late Widget emptyWidget;
  late Timer _timer;
  @override
  void initState() {
    PostBoughtProvider postBoughtProvider =
        Provider.of<PostBoughtProvider>(context, listen: false);
    postBoughtProvider.getDeliveredPost();
    emptyWidget = const CenterRefresh();
    _timer = Timer(const Duration(milliseconds: 7000), () {
      if (postBoughtProvider.deliveredPosts.isEmpty) {
        setState(() {
          emptyWidget = const CenterNotifyEmpty();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    PostBoughtProvider postBoughtProvider =
        Provider.of<PostBoughtProvider>(context);
    List<Post> posts = postBoughtProvider.deliveredPosts;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => postBoughtProvider.getDeliveredPost(),
        child: posts.isEmpty
            ? Center(child: emptyWidget)
            : ListView.builder(
                itemBuilder: ((context, i) {
                  Post post = posts[i];
                  Color titleColor = i % 2 == 0
                      ? Colors.white
                      : Colors.black.withOpacity(0.04);
                  return ListTile(
                    tileColor: titleColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 16,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: post.imageUrl.isEmpty
                              ? const Icon(Icons.image_aspect_ratio_outlined)
                              : Image.network(post.imageUrl),
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          post.title,
                          style: PrimaryFont.semiBold(16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Giá : ${post.price}00đ',
                          style: PrimaryFont.regular(18)
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                            'Ngày tạo : ${post.lastUpdatedAt.add(const Duration(hours: 7)).toString().substring(0, 16)}'),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _showConfirmAccomplishedDialog(post);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green)),
                              child: const Text('Đã nhận hàng'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _showConfirmFailureDialog(post);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red)),
                              child: const Text('Chưa nhận hàng'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  );
                }),
                itemCount: posts.length,
              ),
      ),
    );
  }

  Future<void> _showConfirmAccomplishedDialog(Post post) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          PostBoughtProvider postBoughtProvider =
              Provider.of<PostBoughtProvider>(context);
          return AlertDialog(
            title: const Text('Xác nhận'),
            content: const SingleChildScrollView(
              child:
                  Text('Bạn xác nhận đã đã nhận được hàng cho đơn hàng này ?'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await postBoughtProvider.makeAccomplishedPost(
                      context, post.id);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text('Xác nhận'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('Thoát'),
              )
            ],
          );
        });
  }

  Future<void> _showConfirmFailureDialog(Post post) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          PostBoughtProvider postBoughtProvider =
              Provider.of<PostBoughtProvider>(context);
          return AlertDialog(
            title: const Text('Xác nhận'),
            content: const SingleChildScrollView(
              child:
                  Text('Bạn xác nhận đã đã nhận được hàng cho đơn hàng này ?'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await postBoughtProvider.makeFailurePost(context, post.id);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text('Xác nhận'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('Thoát'),
              )
            ],
          );
        });
  }
}
