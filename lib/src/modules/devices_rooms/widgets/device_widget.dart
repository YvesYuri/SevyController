import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:controller/src/data/model/device_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../data/utils/animations_util.dart';
import '../devices_rooms_controller.dart';

class DeviceWidget extends StatelessWidget {
  DeviceModel? device;
  DeviceWidget({this.device, super.key});

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

  Widget searchDevices(BuildContext context) {
    return Container(
      height: 200,
      width: 368,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              alignment: Alignment.center,
              child: Lottie.asset(
                height: 130,
                AnimationsUtil.searchAnimation,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              alignment: Alignment.center,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  RotateAnimatedText("Searching for devices...",
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      duration: const Duration(
                        seconds: 2,
                      )),
                  RotateAnimatedText(
                      "Make sure you've entered the correct Wi-Fi password.",
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      duration: const Duration(
                        seconds: 2,
                      )),
                  RotateAnimatedText(
                      "Note: The device must support 2.4GHz Wi-Fi.",
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      duration: const Duration(
                        seconds: 2,
                      )),
                  RotateAnimatedText(
                      "Check if the device is turned on and flashing blue.",
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      duration: const Duration(
                        seconds: 2,
                      )),
                  RotateAnimatedText(
                      "Ensure that the device is within range of the Wi-Fi signal.",
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      duration: const Duration(
                        seconds: 2,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget foundDevices(
      BuildContext contex, DevicesRoomsController devicesRoomsController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: devicesRoomsController.foundDevices.length,
            itemBuilder: (context, index) {
              final foundDevice = devicesRoomsController.foundDevices[index];
              return ListTile.selectable(
                leading: SvgPicture.asset(
                  devicesRoomsController.getDeviceIcon(foundDevice.model!),
                  height: 37,
                  width: 37,
                  alignment: Alignment.center,
                ),
                title: Text(foundDevice.model!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(foundDevice.serialNumber!),
                trailing: Center(
                  child: IconButton(
                    icon: const Icon(FluentIcons.chevron_right),
                    onPressed: () {
                      // devicesRoomsController.addDevice(foundDevice);
                    },
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget wifiCredentials(
      BuildContext context, DevicesRoomsController devicesRoomsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 3,
          ),
          child: Text(
            "SSID",
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
          controller: devicesRoomsController.addDeviceWifiSSID,
          expands: false,
          enabled: false,
        ),
        const SizedBox(
          height: 7,
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 3,
          ),
          child: Text(
            "BSSID",
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
          controller: devicesRoomsController.addDeviceWifiBSSID,
          expands: false,
          enabled: false,
        ),
        const SizedBox(
          height: 7,
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 3,
          ),
          child: Text(
            "Password",
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
          controller: devicesRoomsController.addDeviceWifiPassword,
          obscureText: true,
          expands: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DevicesRoomsController>(
        builder: (context, devicesRoomsController, child) {
      Widget content;
      switch (devicesRoomsController.devicesRoomsState) {
        case DevicesRoomsState.newDevice:
          {
            content = wifiCredentials(context, devicesRoomsController);
          }
          break;

        case DevicesRoomsState.searchDevices:
          {
            content = searchDevices(context);
          }
          break;

        case DevicesRoomsState.foundDevices:
          {
            content = foundDevices(context, devicesRoomsController);
          }
          break;

        default:
          {
            content = wifiCredentials(context, devicesRoomsController);
          }
          break;
      }
      return Stack(
        children: [
          ContentDialog(
            title: Text(device != null ? 'Edit Device' : 'New Device'),
            content: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: content,
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FilledButton(
                child: Text(device != null ? 'Save' : 'Search'),
                onPressed: () async {
                  if (devicesRoomsController.validateWifiCredentials()) {
                    await devicesRoomsController.searchDevices();
                  } else {
                    showMessage(context, "Error", "Please the pass field",
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
  }
}
