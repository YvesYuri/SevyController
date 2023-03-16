import 'package:auto_animated/auto_animated.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as material;
import 'devices_rooms_controller.dart';

class DevicesRoomsView extends StatefulWidget {
  const DevicesRoomsView({super.key});

  @override
  State<DevicesRoomsView> createState() => _DevicesRoomsViewState();
}

class _DevicesRoomsViewState extends State<DevicesRoomsView> {
  @override
  void initState() {
    super.initState();
    var devicesRoomsController =
        Provider.of<DevicesRoomsController>(context, listen: false);
    devicesRoomsController.subscribeToRooms();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 2));
      // print(devicesRoomsController.rooms.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Consumer<DevicesRoomsController>(
          builder: (context, devicesRoomsController, child) {
        return ScaffoldPage(
          header: PageHeader(
            title: const Text('Devices & Rooms'),
            commandBar: CommandBar(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.lightbulb),
                  label: const Text('Add Device'),
                  onPressed: () {},
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.room),
                  label: const Text('Add Room'),
                  onPressed: () {},
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.sort),
                  label: const Text('Reorder Rooms'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          content: LiveList.options(
            padding: const EdgeInsets.all(24),
            itemCount: 4,
            options: const LiveOptions(
              delay: Duration(milliseconds: 250),
              showItemInterval: Duration(milliseconds: 125),
              showItemDuration: Duration(milliseconds: 250),
              visibleFraction: 0.02,
              reAnimateOnVisibility: true,
            ),
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'Living Room',
                            style: FluentTheme.of(context).typography.subtitle,
                          ),
                        ),
                        material.Material(
                          color: Colors.transparent,
                          child: material.PopupMenuButton(
                            icon: Icon(
                              FluentIcons.more,
                              color: FluentTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            elevation: 6,
                            iconSize: 22,
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
                              return <material.PopupMenuEntry>[
                                material.PopupMenuItem(
                                  height: 30,
                                  value: 3,
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
                                        "Rename",
                                        style: FluentTheme.of(context)
                                            .typography
                                            .body,
                                      ),
                                    ],
                                  ),
                                ),
                                material.PopupMenuItem(
                                  height: 30,
                                  value: 3,
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
                                        style: FluentTheme.of(context)
                                            .typography
                                            .body,
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              // if (value == 1) {
                              //   homeController.changeBuildingEdition(true);
                              //   showBuildingPopUp();
                              // } else if (value == 2) {
                              //   showDeleteBuildingPopUp();
                              // } else if (value == 3) {
                              //   homeController.changeBuildingEdition(false);
                              //   showBuildingPopUp();
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: FluentTheme.of(context).brightness ==
                                Brightness.light
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                      height: 120,
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: const Text('No devices in this room yet.'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
