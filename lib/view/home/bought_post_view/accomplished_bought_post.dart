import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_bought_provider.dart';
import 'package:old_stuff_exchange/widgets/center_refresh/center_refresh.dart';
import 'package:provider/provider.dart';

class AccomplishedBoughtPost extends StatefulWidget {
  const AccomplishedBoughtPost({Key? key}) : super(key: key);

  @override
  State<AccomplishedBoughtPost> createState() => _AccomplishedBoughtPostState();
}

class _AccomplishedBoughtPostState extends State<AccomplishedBoughtPost> {
  late Widget emptyWidget;
  late Timer _timer;
  @override
  void initState() {
    PostBoughtProvider postBoughtProvider =
        Provider.of<PostBoughtProvider>(context, listen: false);
    postBoughtProvider.getAccomplishedPost();
    emptyWidget = const CenterRefresh();
    _timer = Timer(const Duration(milliseconds: 10000), () {
      if (postBoughtProvider.accomplishedPosts.isEmpty) {
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
    List<Post> posts = postBoughtProvider.accomplishedPosts;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => postBoughtProvider.getAccomplishedPost(),
        child: posts.isEmpty
            ? Center(child: emptyWidget)
            : ListView.builder(
                itemBuilder: ((context, i) {
                  Post post = posts[i];
                  return ListTile(
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
                          height: 16,
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
                          post.description,
                          style: PrimaryFont.extraLight(16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Giá : ${post.price}00',
                          style: PrimaryFont.regular(18)
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                            'Ngày tạo : ${post.lastUpdatedAt.add(const Duration(hours: 7)).toString().substring(0, 16)}')
                      ],
                    ),
                  );
                }),
                itemCount: posts.length,
              ),
      ),
    );
  }
}
