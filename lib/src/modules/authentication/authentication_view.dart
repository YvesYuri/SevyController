import 'package:controller/src/modules/authentication/authentication_controller.dart';
import 'package:controller/src/modules/authentication/widgets/internet_connection_validator_widget.dart';
import 'package:controller/src/modules/authentication/widgets/login_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  void showInternetConnectionValidator() {
    showDialog(
      context: context,
      builder: (context) {
        return const InternetConnectionValidatorWidget();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<AuthenticationController>(context, listen: false).getConnectivity();  
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Sevy Controller'),
      ),
      content: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The Sevy Controller app is a smart home application that lets you control a variety of devices remotely using your smartphone or tablet. With a user-friendly interface and advanced automation features, it's a convenient tool for managing your home devices.",
            ),
            const SizedBox(height: 24),
            FilledButton(
              child: const Text("Start"),
              onPressed: () {
                showInternetConnectionValidator();
              },
            )
          ],
        ),
      ),
    );
  }
}
