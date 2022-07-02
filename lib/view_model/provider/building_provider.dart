import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/building.dart';
import 'package:old_stuff_exchange/repository/implement/building_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class BuildingProvider with ChangeNotifier {
  Building? _selectedItem;
  Building? get selectedItem => _selectedItem;
  List<Building>? apartments;
  final SecureStorage secureStorage = SecureStorage();

  Future<void> getList(String apartmentId) async {
    apartments = await BuildingRepImp().getList(apartmentId);
    notifyListeners();
  }
}
