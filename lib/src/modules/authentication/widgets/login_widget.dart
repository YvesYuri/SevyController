import 'package:controller/src/modules/authentication/authentication_controller.dart';
import 'package:controller/src/modules/authentication/widgets/create_account_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: authenticationController.newUser
                ? const CreateAccountWidget()
                : ContentDialog(
                    // key: const Key('2'),
                    title: const Text('Login'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        TextBox(
                          controller:
                              authenticationController.loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          placeholder: 'Email',
                        ),
                        const SizedBox(height: 10),
                        TextBox(
                          controller:
                              authenticationController.loginPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText:
                              authenticationController.passwordLoginVisible
                                  ? false
                                  : true,
                          placeholder: 'Password',
                          suffix: IconButton(
                            icon: Icon(
                              authenticationController.passwordLoginVisible
                                  ? FluentIcons.hide3
                                  : FluentIcons.view,
                            ),
                            onPressed: () {
                              authenticationController
                                  .changePasswordLoginVisible();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New User? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                authenticationController.changeNewUser(true);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  'Create account!',
                                  style: TextStyle(
                                    color: FluentTheme.of(context).accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      Button(
                        child: const Text('Cancel'),
                        onPressed: () {
                          // myAccountController!.changeNewUser(false);
                          Navigator.pop(context);
                          // Delete file here
                        },
                      ),
                      FilledButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          if (authenticationController.validateLogin()) {
                            var result =
                                await authenticationController.signIn();
                            if (authenticationController.authenticationState ==
                                AuthenticationState.error) {
                              showMessage(context, 'Error', result,
                                  InfoBarSeverity.error);
                            } else if (authenticationController.authenticationState ==
                                AuthenticationState.success) {
                              showMessage(context, 'Success', result,
                                  InfoBarSeverity.success);
                            }
                          } else {
                            showMessage(
                                context,
                                'Error',
                                'Please provide a valid email address and a password with at least 6 characters to proceed.',
                                InfoBarSeverity.error);
                            // }
                          }
                        },
                      ),
                    ],
                  ),
          ),
          Visibility(
            visible: authenticationController.authenticationState == AuthenticationState.loading,
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
