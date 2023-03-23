import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../model/user_model.dart';

class AuthenticationService {
  static final AuthenticationService instance =
      AuthenticationService._internal();

  factory AuthenticationService() {
    return instance;
  }

  AuthenticationService._internal();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> authStateChanges() =>
      firebaseAuth.authStateChanges().map((event) => event == null
          ? UserModel()
          : UserModel(
              id: event.uid,
              email: event.email,
              displayName: event.displayName,
              registerDate: DateFormat("dd/MM/yyyy")
                  .format(event.metadata.creationTime!)));

  Future<String> signIn(String email, String password) async {
    UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!;
    return user.email!;
  }

  Future<User> signUp(String displayName, String email, String password) async {
    late StreamSubscription subscription;
    UserCredential result = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      subscription = firebaseAuth.authStateChanges().listen((User? user) async {
        await user!.updateDisplayName(displayName);
        await user.sendEmailVerification();
        subscription.cancel();
      });
      return value;
    });
    User user = result.user!;
    return user;
  }

  void signOut() async {
    //await Future.delayed(const Duration(seconds: 1));
    return firebaseAuth.signOut();
  }

  UserModel getCurrentUser() {
    User? user = firebaseAuth.currentUser;
    return UserModel(
        email: user?.email,
        displayName: user?.displayName,
        registerDate: user == null ? null :
            DateFormat("dd/MM/yyyy").format(user.metadata.creationTime!));
  }
}
