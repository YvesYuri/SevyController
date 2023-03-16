import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/services/cloud_database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import '../../data/model/room_model.dart';
import '../../data/model/user_model.dart';
import '../../data/services/authentication_service.dart';

enum AuthenticationState {
  initial,
  loading,
  success,
  error,
}

class AuthenticationController extends ChangeNotifier {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController createAccountEmailController = TextEditingController();
  TextEditingController createAccountPasswordController =
      TextEditingController();
  TextEditingController createAccountConfirmPasswordController =
      TextEditingController();
  TextEditingController createAccountDisplayNameController =
      TextEditingController();
  bool passwordLoginVisible = false;
  late StreamSubscription subscription;
  bool hasInternetConnection = false;
  bool newUser = false;

  var authenticationState = AuthenticationState.initial;

  void changePasswordLoginVisible() {
    passwordLoginVisible = !passwordLoginVisible;
    notifyListeners();
  }

  Stream<UserModel?> get authStateChanges =>
      AuthenticationService.instance.authStateChanges();

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      hasInternetConnection = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

  void changeNewUser(bool value) {
    newUser = value;
    notifyListeners();
  }

  void clearLoginControllers() {
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  void clearCreateAccountControllers() {
    createAccountEmailController.clear();
    createAccountPasswordController.clear();
    createAccountConfirmPasswordController.clear();
    createAccountDisplayNameController.clear();
  }

  bool validateLogin() {
    bool emailIsValid = loginEmailController.text.isNotEmpty &&
        EmailValidator.validate(loginEmailController.text);
    bool passwordIsValid = loginPasswordController.text.isNotEmpty &&
        loginPasswordController.text.length >= 6;
    bool loginIsValid = emailIsValid && passwordIsValid;
    return loginIsValid;
  }

  bool validateCreateAccout() {
    bool displayNameIsValid =
        createAccountDisplayNameController.text.isNotEmpty &&
            createAccountDisplayNameController.text.length >= 4;
    bool emailIsValid = createAccountEmailController.text.isNotEmpty &&
        EmailValidator.validate(createAccountEmailController.text);
    bool passwordIsValid = createAccountPasswordController.text.isNotEmpty &&
        createAccountPasswordController.text.length >= 6;
    bool confirmPasswordIsValid =
        createAccountConfirmPasswordController.text.isNotEmpty &&
            createAccountConfirmPasswordController.text ==
                createAccountPasswordController.text;
    bool signUpIsValid = displayNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        confirmPasswordIsValid;
    return signUpIsValid;
  }

  Future<String> signIn() async {
    authenticationState = AuthenticationState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      String result = await AuthenticationService.instance
          .signIn(loginEmailController.text, loginPasswordController.text);
      clearLoginControllers();
      authenticationState = AuthenticationState.success;
      notifyListeners();
      return result;
    } catch (e) {
      authenticationState = AuthenticationState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> signUp() async {
    authenticationState = AuthenticationState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      var result = await AuthenticationService.instance.signUp(
        createAccountDisplayNameController.text,
        createAccountEmailController.text,
        createAccountPasswordController.text,
      );
      CloudDatabaseService.instance.createUser(
        UserModel(
          uid: result.uid,
          email: result.email!,
          displayName: createAccountDisplayNameController.text,
          registerDate:
              DateFormat('dd/MM/yyyy').format(result.metadata.creationTime!),
        ),
      );
      var buildingUid = await CloudDatabaseService.instance.createBuilding(
        BuildingModel(
          name: 'Home',
          cover: '',
          owner: result.email!,
        ),
      );
      CloudDatabaseService.instance.createRoom(RoomModel(
        name: 'Living Room',
        owner: result.email!,
        buildingUid: buildingUid
      ));
      CloudDatabaseService.instance.createRoom(RoomModel(
        name: 'Bedroom',
        owner: result.email!,
        buildingUid: buildingUid
      ));
      clearCreateAccountControllers();
      authenticationState = AuthenticationState.success;
      notifyListeners();
      return result.email!;
    } catch (e) {
      authenticationState = AuthenticationState.error;
      notifyListeners();
      return e.toString();
    }
  }
}
