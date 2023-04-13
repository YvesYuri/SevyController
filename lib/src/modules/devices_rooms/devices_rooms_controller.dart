import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/utils/devices_icons_util.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;

import '../../data/model/device_model.dart';
import '../../data/model/room_model.dart';
import '../../data/services/authentication_service.dart';
import '../../data/services/cloud_database_service.dart';

enum DevicesRoomsState {
  initial,
  loading,
  newDevice,
  searchDevices,
  foundDevices,
  configDevices,
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
  late StreamSubscription internetSubscription;
  bool hasInternetConnection = true;
  List<RoomModel> get roomsByBuilding => rooms
      .where((element) => element.buildingUid == currentBuilding!.id)
      .toList();

  TextEditingController addDeviceWifiSSID = TextEditingController();
  TextEditingController addDeviceWifiBSSID = TextEditingController();
  TextEditingController addDeviceWifiPassword = TextEditingController();
  final info = NetworkInfo();
  final deviceSearchProvisioner = Provisioner.espTouch();
  List<DeviceModel> foundDevices = [];

  final devicesIconsUtil = DevicesIconsUtil();

  void getConnectivity() {
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      hasInternetConnection = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

  String getDeviceIcon(String model) {
    return devicesIconsUtil.getDeviceIcon(model);
  }

  void subscribeDeviceSearchProvisioner() {
    deviceSearchProvisioner.listen((response) async {
      var deviceInfoUrl =
          Uri.parse('http://${response.ipAddressText}/deviceInfo');
      var deviceInfoResponse = await http.get(deviceInfoUrl);
      var foundDevice = DeviceModel(
        id: (foundDevices.length + 1).toString(),
        bssid: response.bssidText,
        ip: response.ipAddressText,
        ssid: addDeviceWifiSSID.text,
      );
      if (devicesRoomsState == DevicesRoomsState.searchDevices) {
        devicesRoomsState = DevicesRoomsState.foundDevices;
        notifyListeners();
      }
      if (deviceInfoResponse.statusCode == 200) {
        var jsonResponse = jsonDecode(deviceInfoResponse.body);
        foundDevice.model = jsonResponse['model'];
        foundDevice.serialNumber = jsonResponse['serialNumber'];
      } else {
        foundDevice.model = 'Unknown';
        foundDevice.serialNumber = 'Unknown';
      }
      foundDevices.add(foundDevice);
      notifyListeners();
    });
  }

  void getWifiInfo() async {
    devicesRoomsState = DevicesRoomsState.newDevice;
    var wifiName = await info.getWifiName();
    var bssid = (await info.getWifiBSSID())!.toUpperCase();
    addDeviceWifiSSID.text = wifiName!;
    addDeviceWifiBSSID.text = bssid.substring(0, 17);
  }

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

  Future<void> searchDevices() async {
    devicesRoomsState = DevicesRoomsState.searchDevices;
    notifyListeners();
    await deviceSearchProvisioner.start(
      ProvisioningRequest.fromStrings(
        ssid: addDeviceWifiSSID.text,
        bssid: addDeviceWifiBSSID.text,
        password: addDeviceWifiPassword.text,
      ),
    );
    // await Future.delayed(const Duration(seconds: 2), () {});
    // addDeviceState.value = AddDeviceState.success;
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

  bool validateWifiCredentials() {
    if (addDeviceWifiSSID.text.isEmpty ||
        addDeviceWifiBSSID.text.isEmpty ||
        addDeviceWifiPassword.text.isEmpty) {
      return false;
    }
    return true;
  }
}
