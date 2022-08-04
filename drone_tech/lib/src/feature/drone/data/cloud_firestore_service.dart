import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drone_tech/src/feature/drone/domain/drone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//This class does all the exchange with our Firestore database.

class FirestoreDataBaseService {
  //The instanes below lets us access Firestore.

  final CollectionReference collectionDrones =
      FirebaseFirestore.instance.collection('drones');

  Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('drones').snapshots();

  //Adds a new drone to our already existing list of drones.
  //it makes use of Firestore .add() method from Firestore package.
  Future<void> addDrone(Drones drone) async {
    await collectionDrones.add({
      'date': DateTime.now(),
      'idtag': drone.idTag,
      'manufacturer': drone.manufacturer,
      'served': drone.served,
      'weightcapacity': drone.weightCapacity,
    });
  }

  //update() method from Firestore package.
  Future<void> updateDrone(String documentId, bool status) async {
    await collectionDrones.doc(documentId).update({
      'served': !status,
    });
  }

  //delete() method also from the Firestore package.
  Future<void> deleteDrone(String id) async {
    await collectionDrones.doc(id).delete();
  }
}

//Provides all our reference (ref) to other providers outside this class.
final firestoreDBProvider = Provider<FirestoreDataBaseService>((ref) {
  return FirestoreDataBaseService();
});
