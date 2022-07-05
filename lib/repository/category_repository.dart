

import 'package:old_stuff_exchange/model/entity/category.dart';

abstract class CategoryReq {
  Future<List<Category>> getAll();
}
