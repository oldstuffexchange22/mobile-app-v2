import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/repository/implement/apartment_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class ApartmentProvider with ChangeNotifier {
  Apartment? _selectedItem;
  Apartment? get selectedItem => _selectedItem;
  List<Apartment>? apartments;
  final SecureStorage secureStorage = SecureStorage();

  Future<void> getList() async {
    apartments = await ApartmentReqImp().getList();
    notifyListeners();
  }
}
