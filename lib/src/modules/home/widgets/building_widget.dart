import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../home_controller.dart';

class BuildingWidget extends StatelessWidget {
  const BuildingWidget({super.key});

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
    return Consumer<HomeController>(builder: (context, homeController, child) {
      return Stack(
        children: [
          ContentDialog(
            title: Text(homeController.buildingEdition
                ? 'Edit Building'
                : 'New Building'),
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
                  controller: homeController.buildingName,
                  placeholder: 'Ex: Office',
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
                child: Text(homeController.buildingEdition ? 'Save' : 'Add'),
                onPressed: () async {
                  if (homeController.validateBuilding()) {
                    if (homeController.buildingEdition) {
                      await homeController.updateBuilding();
                    if (homeController.homeState == HomeState.success) {
                      showMessage(context, 'Success',
                          'Building updated successfully', InfoBarSeverity.info);
                      Navigator.pop(context);
                    } else if (homeController.homeState == HomeState.error) {
                      showMessage(context, 'Error',
                          'Error updated building', InfoBarSeverity.error);
                    } 
                    } else {
                      await homeController.createBuilding();
                    if (homeController.homeState == HomeState.success) {
                      showMessage(context, 'Success',
                          'Building created successfully', InfoBarSeverity.info);
                      Navigator.pop(context);
                    } else if (homeController.homeState == HomeState.error) {
                      showMessage(context, 'Error',
                          'Error creating building', InfoBarSeverity.error);
                    } 
                    }
                  } else {
                    showMessage(context, 'Error',
                        'Please fill name field', InfoBarSeverity.error);
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
  }
}
