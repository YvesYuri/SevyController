

import 'package:controller/firebase_options.dart';
import 'package:controller/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Firestore.initialize(DefaultFirebaseOptions.currentPlatform.projectId);
  runApp(const SevyController());
}
