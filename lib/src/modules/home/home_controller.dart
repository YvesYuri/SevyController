import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/model/user_model.dart';
import 'package:controller/src/data/services/cloud_database_service.dart';
import 'package:controller/src/data/services/database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../data/model/room_model.dart';
import '../../data/services/authentication_service.dart';

enum HomeState {
  initial,
  loading,
  success,
  error,
}

class HomeController extends ChangeNotifier {
  var homeState = HomeState.initial;

  int currentPage = 0;
  bool showMenu = false;
  late StreamSubscription usersSubscription;
  List<UserModel> users = [];
  List<BuildingModel> buildings = [];
  TextEditingController buildingName = TextEditingController();
  bool buildingEdition = false;
  BuildingModel? currentBuilding;
  // TapDownDetails tapDownDetails = TapDownDetails();
  late StreamSubscription internetSubscription;
  bool hasInternetConnection = false;

  bool lab = false;

  UserModel? get currentUser => AuthenticationService.instance.getCurrentUser();

  void changePage(int value) {
    currentPage = value;
    notifyListeners();
  }

  void changeShowMenu() {
    showMenu = !showMenu;
    notifyListeners();
  }

  void openMenu() {
    showMenu = true;
    notifyListeners();
  }

  // void changeTapDownDetails(TapDownDetails details) {
  //   tapDownDetails = details;
  //   notifyListeners();
  // }

  void changeCurrentBuilding(BuildingModel? building) {
    currentBuilding = building;
    notifyListeners();
  }

  void getConnectivity() {
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      hasInternetConnection = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    AuthenticationService.instance.signOut();
    homeState = HomeState.success;
    notifyListeners();
  }

  void changeBuildingEdition(bool value) {
    buildingEdition = value;
    if (buildingEdition) {
      buildingName.text = currentBuilding!.name!;
    } else {
      buildingName.clear();
    }
    notifyListeners();
  }

  bool validateBuilding() {
    if (buildingName.text.isEmpty) {
      return false;
    }
    return true;
  }

  void clearBuilding() {
    buildingName.clear();
    notifyListeners();
  }

  void subscribeUsers() {
    usersSubscription = CloudDatabaseService.instance.users.listen((event) {
      List<UserModel> userList = [];
      event.forEach((e) {
        userList.add(UserModel.fromJson(e));
      });
      users = userList;
      notifyListeners();
    });
  }

  void enableCloudSync() {
    //building
    late StreamSubscription cloudSyncBuildingSubscription;
    cloudSyncBuildingSubscription =
        CloudDatabaseService.instance.buildings.listen((event) async {
      await Future.delayed(const Duration(seconds: 2));
      List<BuildingModel> cloudBuildings = [];
      event.forEach((e) async {
        var building = BuildingModel.fromJson(e);
        cloudBuildings.add(building);
      });
      var currentUser = AuthenticationService.instance.getCurrentUser();
      var cloudBuildingUser = cloudBuildings
          .where((element) => element.owner == currentUser.email)
          .toList();
      var localBuildings = await DatabaseService.instance.readBuildings();
      for (var building in cloudBuildingUser) {
        if (localBuildings.any((element) => element.id == building.id)) {
          if (localBuildings
                  .firstWhere((element) => element.id == building.id)
                  .name !=
              building.name) {
            try {
              await DatabaseService.instance.updateBuilding(building);
            } catch (e) {
              print(e);
            }
          }
        } else {
          try {
            await DatabaseService.instance.createBuilding(building);
          } catch (e) {
            print(e);
          }
        }
      }
      for (var building in localBuildings) {
        if (!cloudBuildingUser.any((element) => element.id == building.id)) {
          try {
            await DatabaseService.instance.deleteBuilding(building.id!);
          } catch (e) {
            print(e);
          }
        }
      }
    });
    //room
    late StreamSubscription cloudSyncRoomSubscription;
    cloudSyncRoomSubscription =
        CloudDatabaseService.instance.rooms.listen((event) async {
      await Future.delayed(const Duration(seconds: 2));
      List<RoomModel> cloudRooms = [];
      event.forEach((e) async {
        var room = RoomModel.fromJson(e);
        cloudRooms.add(room);
      });
      var currentUser = AuthenticationService.instance.getCurrentUser();
      var cloudRoomUser = cloudRooms
          .where((element) => element.owner == currentUser.email)
          .toList();
      var localRooms = await DatabaseService.instance.readRooms();
      for (var room in cloudRoomUser) {
        if (localRooms.any((element) => element.id == room.id)) {
          if (localRooms.firstWhere((element) => element.id == room.id).name !=
              room.name) {
            try {
              await DatabaseService.instance.updateRoom(room);
            } catch (e) {
              print(e);
            }
          }
        } else {
          try {
            await DatabaseService.instance.createRoom(room);
          } catch (e) {
            print(e);
          }
        }
      }
      for (var room in localRooms) {
        if (!cloudRoomUser.any((element) => element.id == room.id)) {
          try {
            await DatabaseService.instance.deleteRoom(room.id!);
          } catch (e) {
            print(e);
          }
        }
      }
    });
  }

  void subscribeBuildings() {
    usersSubscription = CloudDatabaseService.instance.buildings.listen((event) {
      List<BuildingModel> buildingList = [];
      var currentUser = AuthenticationService.instance.getCurrentUser();
      event.forEach((e) {
        var building = BuildingModel.fromJson(e);
        if (building.owner == currentUser.email) {
          buildingList.add(building);
        }
      });
      buildings = buildingList;
      notifyListeners();
    });
  }

  Future<void> createBuilding() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      var currentUser = AuthenticationService.instance.getCurrentUser();
      var building = BuildingModel(
        name: buildingName.text,
        owner: currentUser.email,
        cover: "",
      );
      await CloudDatabaseService.instance.createBuilding(building);
      clearBuilding();
      currentBuilding = building;
      homeState = HomeState.success;
      notifyListeners();
    } catch (e) {
      homeState = HomeState.error;
      notifyListeners();
    }
  }

  Future<void> updateBuilding() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      currentBuilding!.name = buildingName.text;
      await CloudDatabaseService.instance.updateBuilding(currentBuilding!);
      clearBuilding();
      homeState = HomeState.success;
      notifyListeners();
    } catch (e) {
      homeState = HomeState.error;
      notifyListeners();
    }
  }

  // bool validateDeleteBuilding() {
  //   if (buildings.length == 1) {
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> deleteBuilding() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      await CloudDatabaseService.instance.deleteBuilding(currentBuilding!);
      await Future.delayed(const Duration(seconds: 2));
      currentBuilding = buildings.first;
      homeState = HomeState.success;
      notifyListeners();
    } catch (e) {
      homeState = HomeState.error;
      notifyListeners();
    }
  }
}
