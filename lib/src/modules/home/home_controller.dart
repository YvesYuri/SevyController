import 'dart:async';

import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/model/user_model.dart';
import 'package:controller/src/data/services/cloud_database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
  bool showMenu = true;
  late StreamSubscription usersSubscription;
  List<UserModel> users = [];
  List<BuildingModel> buildings = [];
  TextEditingController buildingName = TextEditingController();
  bool buildingEdition = false;
  BuildingModel? currentBuilding;
  TapDownDetails tapDownDetails = TapDownDetails();

  UserModel? get currentUser => AuthenticationService.instance.getCurrentUser();

  void changePage(int value) {
    currentPage = value;
    notifyListeners();
  }

  void changeShowMenu() {
    showMenu = !showMenu;
    notifyListeners();
  }

  void changeTapDownDetails(TapDownDetails details) {
    tapDownDetails = details;
    notifyListeners();
  }

  void changeCurrentBuilding(BuildingModel? building) {
    currentBuilding = building;
    notifyListeners();
  }

  Future<void> signOut() async {
    homeState = HomeState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await AuthenticationService.instance.signOut();
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