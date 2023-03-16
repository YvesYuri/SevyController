import 'package:controller/src/modules/home/home_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyAccountWidget extends StatelessWidget {
  const MyAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, homeController, child) {
      return Stack(
        children: [
          ContentDialog(
            key: const Key('1'),
            title: const Text('My Account'),
            content: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Row(
                children: [
                  QrImage(
                    foregroundColor:
                        FluentTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    data: homeController.currentUser!.email!,
                    version: QrVersions.auto,
                    size: 70,
                    gapless: false,
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: 2,
                      bottom: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Name: ${homeController.currentUser!.displayName!}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Email: ${homeController.currentUser!.email!}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Member since: ${homeController.currentUser!.registerDate!}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     const Text('Dark Mode: '),
                      //     Switch(
                      //       value: SystemTheme.isDarkMode,
                      //       onChanged: (value) {
                      //         SystemTheme.setTheme(value
                      //             ? SystemThemeMode.dark
                      //             : SystemThemeMode.light);
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Button(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                child: const Text('Logout'),
                onPressed: () async {
                  homeController.signOut();
                },
              ),
            ],
          ),
          Visibility(
            visible: homeController.homeState == HomeState.loading,
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
