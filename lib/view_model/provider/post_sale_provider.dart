import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/repository/implement/user_repository_implement.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class PostSaleProvider with ChangeNotifier {
  List<Post> _inactivePosts = [];
  List<Post> _activePosts = [];
  List<Post> _waitingPosts = [];
  List<Post> _deliveryPosts = [];
  List<Post> _deliveredPosts = [];
  List<Post> _accomplishedPosts = [];
  List<Post> _failurePosts = [];

  List<Post> get inactivePosts => _inactivePosts;
  List<Post> get activePosts => _activePosts;
  List<Post> get waitingPosts => _waitingPosts;
  List<Post> get deliveryPosts => _deliveryPosts;
  List<Post> get deliveredPosts => _deliveredPosts;
  List<Post> get accomplishedPosts => _accomplishedPosts;
  List<Post> get failurePosts => _failurePosts;

  Future<void> getAllPostStatus() async {
    try {
      _inactivePosts = await PostRepImp().getPostStatus(PostStatus.INACTIVE);
      _activePosts = await PostRepImp().getPostStatus(PostStatus.ACTIVE);
      _waitingPosts = await PostRepImp().getPostStatus(PostStatus.WAITING);
      _deliveryPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERY);
      _deliveredPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERED);
      _accomplishedPosts =
          await PostRepImp().getPostStatus(PostStatus.ACCOMPLISHED);
      _failurePosts = await PostRepImp().getPostStatus(PostStatus.FAILURE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostInactive() async {
    try {
      _inactivePosts = await PostRepImp().getPostStatus(PostStatus.INACTIVE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostWaiting() async {
    try {
      _waitingPosts = await PostRepImp().getPostStatus(PostStatus.WAITING);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostActive() async {
    try {
      _activePosts = await PostRepImp().getPostStatus(PostStatus.ACTIVE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostDelivery() async {
    try {
      _deliveryPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERY);
      int count = 0;
      _deliveredPosts.forEach((element) async {
        User? userBuyer = await UserRepImp().getUserById(element.userBought);
        _deliveredPosts[count].userBoughtObject = userBuyer;
        count++;
      });
      // for (var post in _deliveredPosts) {
      //   User? userBuyer = await UserRepImp().getUserById(post.userBought);
      //   _deliveredPosts[count].userBoughtObject = userBuyer;
      //   count++;
      // }
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostDelivered() async {
    try {
      _deliveredPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERED);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostAccomplished() async {
    try {
      _accomplishedPosts =
          await PostRepImp().getPostStatus(PostStatus.ACCOMPLISHED);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostFailure() async {
    try {
      _failurePosts = await PostRepImp().getPostStatus(PostStatus.FAILURE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> deliveredPost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay
          .show(widget: const CustomOverlay(content: '??ang x??? l??'));
      Post? post = await PostRepImp().delivered(postId);
      if (post == null) {
        showToastFail('Giao h??ng th???t b???i');
      } else {
        await getPostDelivery();
        await getPostDelivered();
        showToastSuccess('Giao h??ng th??nh c??ng');
        context.loaderOverlay.hide();
      }
      context.loaderOverlay.hide();
    } catch (e) {
      showToastFail('delivered post fail $e');
    }
  }

  Future<void> inactivePost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay
          .show(widget: const CustomOverlay(content: '??ang x??? l??'));
      Post? post = await PostRepImp().inactive(postId);
      if (post == null) {
        showToastFail('G??? b??i ????ng th???t b???i');
      } else {
        await getPostWaiting();
        await getPostInactive();
        await getPostActive();
        notifyListeners();
        showToastSuccess('G??? b??i ????ng th??nh c??ng');
        context.loaderOverlay.hide();
      }
      context.loaderOverlay.hide();
    } catch (e) {
      showToastFail('delivered post fail $e');
    }
  }
}
