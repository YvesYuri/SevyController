import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ScenesController extends ChangeNotifier {
  late StreamSubscription internetSubscription;
  bool hasInternetConnection = true;
  
  void getConnectivity() {
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      hasInternetConnection = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

}