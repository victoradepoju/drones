import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_tech/src/feature/drone/data/cloud_firestore_service.dart';
import 'package:drone_tech/src/feature/drone/domain/drone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///The core repository. This class is the root of the provider
///(dronePageRepositoryProvider). It's job is to communicate directly with
///our class [FirestoreDataBaseService] class and provider to the Drone Screen.
class DronePageRepository {
  final FirestoreDataBaseService services;
  DronePageRepository({
    required this.services,
  });

  ///Implements the [addDrone] method in our [FirestoreDataBaseService] class.
  Future<void> createDrone(String manufacturer, double weightCapacity) async {
    services.addDrone(
      Drones(
          weightCapacity: weightCapacity,
          manufacturer: manufacturer,
          served: false,
          dateOfAcquisition: DateTime.now()),
    );
  }

  ///Implements the [deleteDrone] mehtod in our [FirestoreDataBaseService] class.
  Future<void> deleteDrone(String id) async {
    services.deleteDrone(id);
  }
}

///Provides directly to the Drone Page and uses Riverpod for state management.
final dronePageRepositoryProvider =
    Provider.autoDispose<DronePageRepository>((ref) {
  return DronePageRepository(services: ref.watch(firestoreDBProvider));
});

///Holds the Drone Status [state] (i.e. Served or Not Serviced) which is boolean.
class DroneStatus extends StateNotifier<bool> {
  final FirestoreDataBaseService services;
  DroneStatus(
    this.services,
  ) : super(false);

  Future<void> changeStatus(String documentId, bool status) async {
    services.updateDrone(documentId, status);
    state = !status;
  }
}

///Provides the [state] where needed.
final droneStatusProvider = StateNotifierProvider<DroneStatus, bool>((ref) {
  final services = ref.watch(firestoreDBProvider);
  return DroneStatus(services);
});
