import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class PostPaymentProvider with ChangeNotifier {
  late Post _currentPost;
  get currentPost => _currentPost;
  set setCurrentPost(Post value) {
    _currentPost = value;
  }

  Future<void> paymentPost(
      BuildContext context, String postId, String walletType) async {
    try {
      context.loaderOverlay
          .show(widget: const CustomOverlay(content: 'Đang thanh toán'));
      Post? post = await PostRepImp().buy(postId, walletType);
      if (post == null) {
        showToastFail('Thanh toán thất bại');
      } else {
        showToastSuccess('Thanh toán thành công');
        context.loaderOverlay.hide();
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/homePage', (route) => false);
      }
      context.loaderOverlay.hide();
    } catch (e) {
      // showToastFail(e.toString());
      context.loaderOverlay.hide();
    }
  }
}
