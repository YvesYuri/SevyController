import 'package:auto_animated/auto_animated.dart';
import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/model/room_model.dart';
import 'package:controller/src/modules/devices_rooms/widgets/room_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as material;
import 'devices_rooms_controller.dart';

class DevicesRoomsView extends StatefulWidget {
  BuildingModel? building;
  DevicesRoomsView({required this.building, super.key});

  @override
  State<DevicesRoomsView> createState() => _DevicesRoomsViewState();
}

class _DevicesRoomsViewState extends State<DevicesRoomsView> {
  void showRoomPopUp(RoomModel? room) {
    showDialog(
      context: context,
      builder: (context) {
        return RoomWidget(
          room: room,
        );
      },
    );
  }

  void showDeleteRoomPopUp(RoomModel room) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<DevicesRoomsController>(
            builder: (context, devicesRoomsController, child) {
          return Stack(
            children: [
              ContentDialog(
                title: const Text('Delete Room'),
                content: Text('Are you sure you want to delete ${room.name}?'),
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
                      await devicesRoomsController.deleteRoom(room);
                      if (devicesRoomsController.devicesRoomsState ==
                          DevicesRoomsState.success) {
                        showMessage(context, 'Success',
                            'Room deleted successfully', InfoBarSeverity.info);
                        Navigator.pop(context);
                      } else if (devicesRoomsController.devicesRoomsState ==
                          DevicesRoomsState.error) {
                        showMessage(context, 'Error', 'Error deleted room',
                            InfoBarSeverity.error);
                      }
                    },
                  ),
                ],
              ),
              Visibility(
                visible: devicesRoomsController.devicesRoomsState ==
                    DevicesRoomsState.loading,
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
    var devicesRoomsController =
        Provider.of<DevicesRoomsController>(context, listen: false);
    devicesRoomsController.subscribeToRooms();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      devicesRoomsController.changeCurrentBuilding(widget.building!);
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
              primaryItems: devicesRoomsController.reorderRooms
                  ? [
                      CommandBarButton(
                        icon: const Icon(FluentIcons.cancel),
                        label: const Text('Cancel'),
                        onPressed: () {
                          showRoomPopUp(null);
                        },
                      ),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.check_mark),
                        label: const Text('Done'),
                        onPressed: () {
                          devicesRoomsController.changeReorderRooms(false);
                        },
                      ),
                    ]
                  : [
                      CommandBarButton(
                        icon: const Icon(FluentIcons.lightbulb),
                        label: const Text('Add Device'),
                        onPressed: () {},
                      ),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.room),
                        label: const Text('Add Room'),
                        onPressed: () {
                          showRoomPopUp(null);
                        },
                      ),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.sort),
                        label: const Text('Reorder Rooms'),
                        onPressed: () {
                          devicesRoomsController.changeReorderRooms(true);
                        },
                      ),
                    ],
            ),
          ),
          content: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: devicesRoomsController.reorderRooms
                ? Expanded(
                    child: ReorderableListView(
                      padding: const EdgeInsets.all(24),
                      proxyDecorator: (child, index, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      header: Text(
                        'Reorder Rooms',
                        style: FluentTheme.of(context).typography.subtitle,
                      ),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          var room = devicesRoomsController.roomsByBuilding
                              .removeAt(oldIndex);
                          devicesRoomsController.roomsByBuilding
                              .insert(newIndex, room);
                        });
                      },
                      children: [
                        for (var room in devicesRoomsController.roomsByBuilding)
                          Container(
                            key: ValueKey(room.id),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: FluentTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.2),
                            ),
                            width: double.maxFinite,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              room.name!,
                              style: TextStyle(
                                color: FluentTheme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : LiveList.options(
                    padding: const EdgeInsets.all(24),
                    itemCount: devicesRoomsController.roomsByBuilding.length,
                    options: const LiveOptions(
                      delay: Duration(milliseconds: 250),
                      showItemInterval: Duration(milliseconds: 125),
                      showItemDuration: Duration(milliseconds: 250),
                      visibleFraction: 0.02,
                      reAnimateOnVisibility: true,
                    ),
                    itemBuilder: (context, index, animation) {
                      var room = devicesRoomsController.roomsByBuilding[index];
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
                                    room.name!,
                                    style: FluentTheme.of(context)
                                        .typography
                                        .subtitle,
                                  ),
                                ),
                                material.Material(
                                  color: Colors.transparent,
                                  child: material.PopupMenuButton(
                                    icon: Icon(
                                      FluentIcons.more,
                                      color:
                                          FluentTheme.of(context).brightness ==
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
                                      if (value == 1) {
                                        devicesRoomsController
                                            .setRoomName(room);
                                        showRoomPopUp(room);
                                      } else if (value == 2) {
                                        showDeleteRoomPopUp(room);
                                      }
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
          ),
        );
      }),
    );
  }
}
