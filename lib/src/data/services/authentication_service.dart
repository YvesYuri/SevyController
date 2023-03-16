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
      firebaseAuth.userChanges().map((event) => event == null
          ? UserModel()
          : UserModel(
              uid: event.uid,
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

  Future<User> signUp(
      String displayName, String email, String password) async {
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!;
    // await user.reload();
    user.updateDisplayName(displayName);
    user.sendEmailVerification();
    return user;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    return firebaseAuth.signOut();
  }

UserModel getCurrentUser() {
    User user = firebaseAuth.currentUser!;
    return UserModel(
        email: user.email,
        displayName: user.displayName,
        registerDate: DateFormat("dd/MM/yyyy")
            .format(user.metadata.creationTime!)
       );
  }
}
