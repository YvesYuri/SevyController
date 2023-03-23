import 'dart:async';

import 'package:controller/src/data/model/building_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../data/model/room_model.dart';
import '../../data/services/authentication_service.dart';
import '../../data/services/cloud_database_service.dart';

enum DevicesRoomsState {
  initial,
  loading,
  success,
  error,
}

class DevicesRoomsController extends ChangeNotifier {
  var devicesRoomsState = DevicesRoomsState.initial;

  List<RoomModel> rooms = [];
  late StreamSubscription roomsSubscription;
  BuildingModel? currentBuilding;
  TextEditingController roomName = TextEditingController();  
  bool reorderRooms = false;
  List<RoomModel> get roomsByBuilding => rooms
      .where((element) => element.buildingUid == currentBuilding!.id)
      .toList();


  void subscribeToRooms() {
    roomsSubscription = CloudDatabaseService.instance.rooms.listen((event) {
      List<RoomModel> roomList = [];
      var currentUser = AuthenticationService.instance.getCurrentUser();
      event.forEach((e) {
        var room = RoomModel.fromJson(e);
        if ((room.owner == currentUser.email)) {
          roomList.add(room);
        }
      });
      rooms = roomList;
      notifyListeners();
    });
  }

  void changeCurrentBuilding(BuildingModel building) {
    currentBuilding = building;
    notifyListeners();
  }

  bool validateRoom() {
    if (roomName.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> createRoom() async {
    devicesRoomsState = DevicesRoomsState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      var currentUser = AuthenticationService.instance.getCurrentUser();
      var room = RoomModel(
        name: roomName.text,
        owner: currentUser.email,
        buildingUid: currentBuilding!.id,
      );
      await CloudDatabaseService.instance.createRoom(room);
      clearRoom();
      devicesRoomsState = DevicesRoomsState.success;
      notifyListeners();
    } catch (e) {
      devicesRoomsState = DevicesRoomsState.error;
      notifyListeners();
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    devicesRoomsState = DevicesRoomsState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      room.name = roomName.text;
      await CloudDatabaseService.instance.updateRoom(room);
      clearRoom();
      devicesRoomsState = DevicesRoomsState.success;
      notifyListeners();
    } catch (e) {
      devicesRoomsState = DevicesRoomsState.error;
      notifyListeners();
    }
  }

  Future<void> deleteRoom(RoomModel room) async {
    devicesRoomsState = DevicesRoomsState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      await CloudDatabaseService.instance.deleteRoom(room);
      await Future.delayed(const Duration(seconds: 2));
      devicesRoomsState = DevicesRoomsState.success;
      notifyListeners();
    } catch (e) {
      devicesRoomsState = DevicesRoomsState.error;
      notifyListeners();
    }
  }

  void clearRoom() {
    roomName.clear();
    notifyListeners();
  }

  void setRoomName(RoomModel room) {
    roomName.text = room.name!;
    notifyListeners();
  }

  void changeReorderRooms(bool value) {
    reorderRooms = value;
    notifyListeners();
  }
}
