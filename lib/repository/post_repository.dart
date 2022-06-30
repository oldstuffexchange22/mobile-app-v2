import 'package:old_stuff_exchange/model/entity/post.dart';

abstract class PostRepository {
  Future<List<Post>?> getList(String status, int pageIndex, int pageSize,
      String? filterWith, String? filterValue, String? categoryId);
}
