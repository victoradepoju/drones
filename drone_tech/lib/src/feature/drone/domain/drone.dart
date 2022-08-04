import 'package:uuid/uuid.dart';

//Uuid package to generate id automatically.
Uuid uuid = const Uuid();

//Modal class for the drones.
class Drones {
  final String idTag;
  final double weightCapacity;
  final String manufacturer;
  final bool served;
  final DateTime dateOfAcquisition;
  Drones({
    required this.weightCapacity,
    required this.manufacturer,
    required this.served,
    required this.dateOfAcquisition,
  }) : idTag = uuid.v4().split('-').sublist(0, 3).join('-');

  @override
  String toString() {
    return 'Drones(idTag: $idTag, weightCapacity: $weightCapacity, manufacturer: $manufacturer, served: $served, dateOfAcquisition: $dateOfAcquisition)';
  }

  @override
  bool operator ==(covariant Drones other) {
    if (identical(this, other)) return true;

    return other.idTag == idTag &&
        other.weightCapacity == weightCapacity &&
        other.manufacturer == manufacturer &&
        other.served == served &&
        other.dateOfAcquisition == dateOfAcquisition;
  }

  @override
  int get hashCode {
    return idTag.hashCode ^
        weightCapacity.hashCode ^
        manufacturer.hashCode ^
        served.hashCode ^
        dateOfAcquisition.hashCode;
  }
}
