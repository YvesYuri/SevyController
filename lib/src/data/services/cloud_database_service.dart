import 'package:firedart/firedart.dart';
import 'package:uuid/uuid.dart';

import '../model/building_model.dart';
import '../model/room_model.dart';
import '../model/user_model.dart';

class CloudDatabaseService {
  static final CloudDatabaseService instance = CloudDatabaseService._internal();

  factory CloudDatabaseService() {
    return instance;
  }

  CloudDatabaseService._internal();

  final Firestore firestoreInstance = Firestore.instance;
  
  //User
  Stream get users => firestoreInstance.collection('user').stream;
  
  Future<void> createUser(UserModel user) async {
    await firestoreInstance.collection('user').document(user.uid!).set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await firestoreInstance.collection('user').document(user.uid!).update(user.toJson());
  }

  Future<void> deleteUser(UserModel user) async {
    await firestoreInstance.collection('user').document(user.uid!).delete();
  }

  //Building
  Stream get buildings => firestoreInstance.collection('building').stream;

  Future<String> createBuilding(BuildingModel building) async {
    var newId = Uuid().v4();
    building.uid = newId;
    await firestoreInstance.collection('building').document(building.uid!).set(building.toJson());
    return newId;
  }

  Future<void> updateBuilding(BuildingModel building) async {
    await firestoreInstance.collection('building').document(building.uid!).update(building.toJson());
  }

  Future<void> deleteBuilding(BuildingModel building) async {
    await firestoreInstance.collection('building').document(building.uid!).delete();
  }

  //Room
  Stream get rooms => firestoreInstance.collection('room').stream;

  Future<void> createRoom(RoomModel room) async {
    var newId = Uuid().v4();
    room.uid = newId;
    await firestoreInstance.collection('room').document(room.uid!).set(room.toJson());
  }

  Future<void> updateRoom(RoomModel room) async {
    await firestoreInstance.collection('room').document(room.uid!).update(room.toJson());
  }

  Future<void> deleteRoom(RoomModel room) async {
    await firestoreInstance.collection('room').document(room.uid!).delete();
  }

}
