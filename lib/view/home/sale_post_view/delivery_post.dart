import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_status_provider.dart';
import 'package:provider/provider.dart';

class DeliveryPost extends StatefulWidget {
  const DeliveryPost({Key? key}) : super(key: key);

  @override
  State<DeliveryPost> createState() => _DeliveryPostState();
}

class _DeliveryPostState extends State<DeliveryPost> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    PostStatusProvider postStatusProvider =
        Provider.of<PostStatusProvider>(context);
    List<Post> posts = postStatusProvider.deliveryPosts;
    return Scaffold(
      body: SizedBox(
        height: screenSize.height,
        child: posts.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giá : ${post.price}00',
                              style: PrimaryFont.regular(18)
                                  .copyWith(color: Colors.red),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green)),
                                onPressed: () async {
                                  await _showConfirmDialog(post);
                                },
                                child: const Text('Đã giao hàng'))
                          ],
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

  Future<void> _showConfirmDialog(Post post) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          PostStatusProvider postStatusProvider = Provider.of(context);
          return AlertDialog(
            title: const Text('Xác nhận'),
            content: const SingleChildScrollView(
              child: Text('Bạn xác nhận đã giao đơn hàng này cho người đặt ?'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await postStatusProvider.deliveredPost(context, post.id);
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
