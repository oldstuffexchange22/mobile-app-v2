import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/model/entity/building.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/implement/apartment_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/building_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/user_repository_implement.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/view/home/home_page.dart';
import 'package:old_stuff_exchange/view/login/signin_page.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class UpdateAddressProvider with ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();
  String _apartmentValue = '';
  String _buildingValue = '';
  String get apartmentValue => _apartmentValue;
  String get buildingValue => _buildingValue;
  set setApartmentValue(String value) {
    _apartmentValue = value;
    notifyListeners();
  }

  set setBuildingValue(String value) {
    _buildingValue = value;
    notifyListeners();
  }

  List<Apartment> _apartments = [];
  List<Building> _buildings = [];
  List<Apartment> get apartments => _apartments;
  List<Building> get buildings => _buildings;

  Future<void> getApartments() async {
    _apartments = await ApartmentReqImp().getList();
    notifyListeners();
  }

  Future<void> getBuildings() async {
    if (_apartmentValue.isEmpty) {
      showToastFail('Select apartment before');
      return;
    }
    _buildings = await BuildingRepImp().getList(_apartmentValue);
    notifyListeners();
  }

  Future<User?> updateUserAddress(
      BuildContext context, String userId, String buildingId) async {
    await secureStorage.deleteSecureData('apartmentId');
    if (userId.isEmpty) {
      showToastFail('User id bị trống');
      return null;
    }
    context.loaderOverlay.show();
    User? user = await UserRepImp().updateAddress(userId, buildingId);
    await secureStorage.writeSecureData(
        'apartmentId', user.building?.apartmentId ?? '');
    notifyListeners();
    final navigator = Navigator.of(context);
    if (user.id.isEmpty) {
      showToastFail('Không thể cập nhật địa chỉ');
    } else {
       Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route route) => false);
    }
    context.loaderOverlay.hide();
    return user;
  }

  void clearAll() {
    _apartmentValue = '';
    _buildingValue = '';
    _buildings = [];
    _apartments = [];
  }

  void clearBuildings() {
    _buildings = [];
    _buildingValue = '';
  }
}
