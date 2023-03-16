import 'package:controller/src/modules/authentication/widgets/login_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../authentication_controller.dart';

class InternetConnectionValidatorWidget extends StatelessWidget {
  const InternetConnectionValidatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationController>(
        builder: (context, authenticationController, child) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: authenticationController.hasInternetConnection
            ? const LoginWidget()
            : ContentDialog(
                // key: const Key('2'),
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
  }
}
