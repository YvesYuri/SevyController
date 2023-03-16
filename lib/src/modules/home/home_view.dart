import 'package:controller/src/modules/devices_rooms/devices_rooms_view.dart';
import 'package:controller/src/modules/home/widgets/building_widget.dart';
import 'package:controller/src/modules/home/widgets/my_account_widget.dart';
import 'package:controller/src/modules/settings/settings_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart' as material;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void showMyAccountPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyAccountWidget();
      },
    );
  }

  void showBuildingPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const BuildingWidget();
      },
    );
  }

  void showDeleteBuildingPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HomeController>(
            builder: (context, homeController, child) {
          return Stack(
            children: [
              ContentDialog(
                title: const Text('Delete Building'),
                content: Text(
                    'Are you sure you want to delete ${homeController.currentBuilding!.name}?'),
                actions: [
                  Button(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FilledButton(
                    child: const Text('Delete'),
                    onPressed: () async {
                      await homeController.deleteBuilding();
                      if (homeController.homeState == HomeState.success) {
                        showMessage(
                            context,
                            'Success',
                            'Building deleted successfully',
                            InfoBarSeverity.info);
                        Navigator.pop(context);
                      } else if (homeController.homeState == HomeState.error) {
                        showMessage(context, 'Error', 'Error deleted building',
                            InfoBarSeverity.error);
                      }
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
      },
    );
  }

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
  void initState() {
    super.initState();
    var homeController = Provider.of<HomeController>(context, listen: false);
    homeController.subscribeBuildings();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 1));
      homeController.changeCurrentBuilding(homeController.buildings.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return NavigationView(
          // appBar: const NavigationAppBar(
          //   title: Text(
          //     "My Room",
          //     style: TextStyle(
          //       // color: Colors.white,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          transitionBuilder: (child, animation) {
            return DrillInPageTransition(animation: animation, child: child);
          },
          pane: NavigationPane(
            displayMode: homeController.showMenu
                ? PaneDisplayMode.open
                : PaneDisplayMode.compact,
            menuButton: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
                bottom: 10,
              ),
              child: IconButton(
                icon: const Icon(FluentIcons.collapse_menu),
                onPressed: () {
                  homeController.changeShowMenu();
                },
              ),
            ),
            selected: homeController.currentPage,
            onChanged: (value) {
              homeController.changePage(value);
            },
            items: [
              PaneItemAction(
                icon: const Icon(FluentIcons.home),
                mouseCursor: MouseCursor.defer,
                title: Text(
                  homeController.currentBuilding == null
                      ? ''
                      : homeController.currentBuilding!.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: material.Material(
                  color: Colors.transparent,
                  child: material.PopupMenuButton(
                    icon: Icon(
                      FluentIcons.more,
                      color:
                          FluentTheme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    elevation: 6,
                    // iconSize: 14,
                    // splashRadius: 10,
                    color: FluentTheme.of(context).menuColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    // child: Icon(
                    //   FluentIcons.more,
                    //   color: FluentTheme.of(context).brightness == Brightness.light
                    //       ? Colors.black
                    //       : Colors.white,
                    // ),
                    itemBuilder: (context) {
                      if (homeController.buildings.length == 1) {
                        return <material.PopupMenuEntry>[
                          material.PopupMenuItem(
                            enabled: false,
                            height: 30,
                            child: Text(
                              homeController.currentBuilding!.name!,
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ),
                          material.PopupMenuItem(
                            height: 30,
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(
                                  FluentIcons.edit,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit",
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                              ],
                            ),
                          ),
                          const material.PopupMenuDivider(),
                          material.PopupMenuItem(
                            height: 30,
                            value: 3,
                            child: Row(
                              children: [
                                const Icon(
                                  FluentIcons.add,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Add building",
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                              ],
                            ),
                          ),
                        ];
                      } else {
                        return <material.PopupMenuEntry>[
                          material.PopupMenuItem(
                            enabled: false,
                            height: 30,
                            child: Text(
                              homeController.currentBuilding!.name!,
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ),
                          material.PopupMenuItem(
                            height: 30,
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(
                                  FluentIcons.edit,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit",
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                              ],
                            ),
                          ),
                          material.PopupMenuItem(
                            height: 30,
                            value: 2,
                            child: Row(
                              children: [
                                const Icon(
                                  FluentIcons.delete,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Delete",
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                              ],
                            ),
                          ),
                          const material.PopupMenuDivider(),
                          ...List.generate(
                            homeController.buildings.length,
                            (index) => material.PopupMenuItem(
                              height: 30,
                              child: Text(
                                homeController.buildings[index].name!,
                                style: FluentTheme.of(context).typography.body,
                              ),
                              onTap: () {
                                homeController.changeCurrentBuilding(
                                    homeController.buildings[index]);
                              },
                            ),
                          ),
                          const material.PopupMenuDivider(),
                          material.PopupMenuItem(
                            height: 30,
                            value: 3,
                            child: Row(
                              children: [
                                const Icon(
                                  FluentIcons.add,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Add building",
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                              ],
                            ),
                          ),
                        ];
                      }
                    },
                    onSelected: (value) {
                      if (value == 1) {
                        homeController.changeBuildingEdition(true);
                        showBuildingPopUp();
                      } else if (value == 2) {
                        showDeleteBuildingPopUp();
                      } else if (value == 3) {
                        homeController.changeBuildingEdition(false);
                        showBuildingPopUp();
                      }
                    },
                  ),
                ),
                onTap: () {},
              ),
              PaneItem(
                icon: const Icon(FluentIcons.favorite_star),
                title: const Text("Favorites"),
                body: Container(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.lightbulb),
                title: const Text("Devices & Rooms"),
                body: const DevicesRoomsView(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.play),
                title: const Text("Scenarios"),
                body: Container(),
              ),
            ],
            footerItems: [
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text("Settings"),
                body: const SettingsView(),
              ),
              PaneItemAction(
                icon: const Icon(FluentIcons.contact),
                title: const Text("My Account"),
                onTap: () async {
                  showMyAccountPopUp();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
