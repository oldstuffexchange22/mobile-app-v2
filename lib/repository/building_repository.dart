import 'package:old_stuff_exchange/model/entity/building.dart';

abstract class BuildingRep {
  Future<List<Building>> getList(String apartmentId);
}
