import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_sale_provider.dart';
import 'package:old_stuff_exchange/widgets/center_refresh/center_refresh.dart';
import 'package:provider/provider.dart';

class ActivePost extends StatefulWidget {
  const ActivePost({Key? key}) : super(key: key);

  @override
  State<ActivePost> createState() => _ActivePostState();
}

class _ActivePostState extends State<ActivePost> {
  late Widget emptyWidget;
  late Timer _timer;
  @override
  void initState() {
    PostSaleProvider postSaleProvider =
        Provider.of<PostSaleProvider>(context, listen: false);
    postSaleProvider.getPostActive();
    emptyWidget = const CenterRefresh();
    _timer = Timer(const Duration(milliseconds: 7000), () {
      if (postSaleProvider.accomplishedPosts.isEmpty && mounted) {
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
    PostSaleProvider postStatusProvider =
        Provider.of<PostSaleProvider>(context);
    List<Post> posts = postStatusProvider.activePosts;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => postStatusProvider.getPostActive(),
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
                          post.description,
                          style: PrimaryFont.extraLight(16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Gi?? : ${post.price}00??',
                              style: PrimaryFont.regular(18)
                                  .copyWith(color: Colors.red),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                                onPressed: () async {
                                  await _showConfirmDialog(post);
                                },
                                child: const Text('H???y b??i vi???t'))
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                            'Ng??y t???o : ${post.lastUpdatedAt.add(const Duration(hours: 7)).toString().substring(0, 16)}'),
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

  Future<void> _showConfirmDialog(Post post) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          PostSaleProvider postStatusProvider =
              Provider.of<PostSaleProvider>(context);
          return AlertDialog(
            title: const Text('X??c nh???n'),
            content: const SingleChildScrollView(
              child: Text('B???n x??c nh???n mu???n h???y ????n h??ng n??y ?'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await postStatusProvider.inactivePost(context, post.id);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text('X??c nh???n'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('Tho??t'),
              )
            ],
          );
        });
  }
}
