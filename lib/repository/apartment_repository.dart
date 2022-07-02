import 'package:old_stuff_exchange/model/entity/apartment.dart';

abstract class ApartmentRep {
  Future<List<Apartment>> getList();
}
