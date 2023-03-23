import 'package:controller/src/data/utils/animations_util.dart';
import 'package:controller/src/data/utils/images_util.dart';
import 'package:controller/src/modules/authentication/authentication_controller.dart';
import 'package:controller/src/modules/authentication/widgets/create_account_widget.dart';
import 'package:controller/src/modules/authentication/widgets/login_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../data/model/user_model.dart';
import '../../data/services/database_service.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  void showLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<AuthenticationController>(
            builder: (context, authenticationController, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: authenticationController.hasInternetConnection
                ? const LoginWidget(
                    key: Key('1'),
                  )
                : ContentDialog(
                    key: const Key('2'),
                    title: const Text('No Internet Connection'),
                    content: const Text(
                        'Please check your internet connection and try again.'),
                    actions: [
                      FilledButton(
                        child: const Text('Ok'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
          );
        });
      },
    );
  }

  void showCreateAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<AuthenticationController>(
            builder: (context, authenticationController, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: authenticationController.hasInternetConnection
                ? const CreateAccountWidget(
                    key: Key('1'),
                  )
                : ContentDialog(
                    key: const Key('2'),
                    title: const Text('No Internet Connection'),
                    content: const Text(
                        'Please check your internet connection and try again.'),
                    actions: [
                      FilledButton(
                        child: const Text('Ok'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthenticationController>(context, listen: false)
          .getConnectivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 500,
          height: double.maxFinite,
          color: FluentTheme.of(context).scaffoldBackgroundColor,
          child: ScaffoldPage.withPadding(
            padding: const EdgeInsets.all(24),
            header: PageHeader(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Image.asset(
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      height: 35,
                      width: 35,
                      ImagesUtil.logo,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('Sevy Controller'),
                ],
              ),
            ),
            content: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create an account or sign in",
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: double.maxFinite,
                        child: const Text("Create Free Account")),
                    onPressed: () async {
                      showCreateAccount();
                      // await DatabaseService.instance.createUser(UserModel(
                      //   id: "fsdfsad",
                      //   displayName: "dasdas",
                      //   email: "asdasd",
                      //   registerDate: "dsadasa",
                      // ));
                      // showInternetConnectionValidator();
                    },
                  ),
                  const SizedBox(height: 24),
                  Button(
                    style: ButtonStyle(
                      backgroundColor: ButtonState.all(
                        FluentTheme.of(context).menuColor,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: double.maxFinite,
                      child: const Text('Sign In'),
                    ),
                    onPressed: () {
                      showLogin();
                    },
                  ),
                ],
              ),
            ),
            bottomBar: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text("Create your account or sign in later? "),
                  MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text("Skip and go to the app",
                          style:
                              TextStyle(decoration: TextDecoration.underline)))
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: FluentTheme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  FluentTheme.of(context).brightness == Brightness.light
                      ? FluentTheme.of(context).accentColor.withOpacity(0.2)
                      : FluentTheme.of(context).accentColor.withOpacity(0.5),
                  FluentTheme.of(context).brightness == Brightness.light
                      ? FluentTheme.of(context).accentColor.withOpacity(0.5)
                      : FluentTheme.of(context).accentColor.withOpacity(0.2),
                ],
              )),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    // alignment: Alignment.bottomRight,
                    child: Lottie.asset(
                      height: 420,
                      AnimationsUtil.introAnimation,
                    ),
                  ),
                  const Text(
                    "The control in the palm of your hand",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.check_mark,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Organize all your devices in one system control",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.check_mark,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Create scenes to control multiple devices at the same time",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.check_mark,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Back up your work on Sevy’s cloud",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.check_mark,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Experience the best smart home control platform for free!",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
