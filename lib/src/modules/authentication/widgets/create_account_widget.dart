import 'package:controller/src/modules/authentication/authentication_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

class CreateAccountWidget extends StatelessWidget {
  const CreateAccountWidget({super.key});

  void showMessage(BuildContext context, String title, String message,
      InfoBarSeverity severity) {
    displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: severity,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationController>(
        builder: (context, authenticationController, child) {
      return Stack(
        children: [
          ContentDialog(
            key: const Key('3'),
            title: const Text('Create Account'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextBox(
                  controller: authenticationController
                      .createAccountDisplayNameController,
                  placeholder: 'Name',
                  textCapitalization: material.TextCapitalization.words,
                ),
                const SizedBox(height: 10),
                TextBox(
                  placeholder: 'Email',
                  controller:
                      authenticationController.createAccountEmailController,
                ),
                const SizedBox(height: 10),
                TextBox(
                  controller:
                      authenticationController.createAccountPasswordController,
                  placeholder: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextBox(
                  controller: authenticationController
                      .createAccountConfirmPasswordController,
                  placeholder: 'Confirm Password',
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Back'),
                onPressed: () {
                  authenticationController.clearCreateAccountControllers();
                  authenticationController.changeNewUser(false);
                },
              ),
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  authenticationController.changeNewUser(false);
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                child: const Text('Create'),
                onPressed: () async {
                  if (authenticationController.validateCreateAccout()) {
                    var result = await authenticationController.signUp();
                    if (authenticationController.authenticationState == AuthenticationState.error) {
                      showMessage(context, 'Error', result, InfoBarSeverity.error);
                    } else if (authenticationController.authenticationState == AuthenticationState.success) {
                      showMessage(
                          context, 'Success', result, InfoBarSeverity.success);
                    }
                  } else {
                    showMessage(
                        context,
                        'Error',
                        'Please provide a name with at least 4 characters, a valid email address, and a password with at least 6 characters to proceed.',
                        InfoBarSeverity.error);
                  }
                },
              ),
            ],
          ),
          Visibility(
            visible: authenticationController.authenticationState ==
                AuthenticationState.loading,
            child: Container(
              // height: 60,
              // width: 60,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 60,
                width: 60,
                child: const FittedBox(
                  fit: BoxFit.fill,
                  child: ProgressRing(
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
