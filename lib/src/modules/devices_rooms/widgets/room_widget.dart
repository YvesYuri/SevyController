import 'package:controller/src/data/model/room_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../devices_rooms_controller.dart';

class RoomWidget extends StatelessWidget {
  RoomModel? room;
  RoomWidget({required this.room, super.key});

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
    return Consumer<DevicesRoomsController>(builder: (context, devicesRoomsController, child) {
      return Stack(
        children: [
          ContentDialog(
            title: Text(room != null
                ? 'Edit Room'
                : 'New Room'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                  ),
                  child: Text(
                    "Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextBox(
                  controller: devicesRoomsController.roomName,
                  placeholder: 'Ex: Living Room',
                  expands: false,
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                child: Text(room != null ? 'Save' : 'Add'),
                onPressed: () async {
                  if (devicesRoomsController.validateRoom()) {
                    if (room != null) {
                      await devicesRoomsController.updateRoom(room!);
                      if (devicesRoomsController.devicesRoomsState == DevicesRoomsState.success) {
                        showMessage(
                            context,
                            'Success',
                            'Room updated successfully',
                            InfoBarSeverity.info);
                        Navigator.pop(context);
                      } else if (devicesRoomsController.devicesRoomsState == DevicesRoomsState.error) {
                        showMessage(context, 'Error', 'Error updated room',
                            InfoBarSeverity.error);
                      }
                    } else {
                      await devicesRoomsController.createRoom();
                      if (devicesRoomsController.devicesRoomsState == DevicesRoomsState.success) {
                        showMessage(
                            context,
                            'Success',
                            'Room created successfully',
                            InfoBarSeverity.info);
                        Navigator.pop(context);
                      } else if (devicesRoomsController.devicesRoomsState == DevicesRoomsState.error) {
                        showMessage(context, 'Error', 'Error creating room',
                            InfoBarSeverity.error);
                      }
                    }
                  } else {
                    showMessage(context, 'Error', 'Please fill name field',
                        InfoBarSeverity.error);
                  }
                },
              ),
            ],
          ),
          Visibility(
            visible: devicesRoomsController.devicesRoomsState == DevicesRoomsState.loading,
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
