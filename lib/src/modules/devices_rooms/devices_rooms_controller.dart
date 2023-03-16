import 'dart:async';

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

  void subscribeToRooms() {
    roomsSubscription = CloudDatabaseService.instance.rooms.listen((event) {
      List<RoomModel> roomList = [];
      var currentUser = AuthenticationService.instance.getCurrentUser();
      event.forEach((e) {
        var room = RoomModel.fromJson(e);
        if (room.owner == currentUser.email) {
          roomList.add(room);
        }
      });
      rooms = roomList;
      notifyListeners();
    });
  }
}
