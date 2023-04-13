import 'package:controller/src/modules/scenes/scenes_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../data/utils/animations_util.dart';

class ScenesView extends StatefulWidget {
  const ScenesView({super.key});

  @override
  State<ScenesView> createState() => _ScenesViewState();
}

class _ScenesViewState extends State<ScenesView> {
  @override
  void initState() {
    super.initState();
    var scenesController =
        Provider.of<ScenesController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scenesController.getConnectivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScenesController>(
        builder: (context, scenesController, child) {
      return Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: scenesController.hasInternetConnection
                ? Container()
                : Container(
                    height: 40,
                    width: double.maxFinite,
                    color: Colors.orange.withOpacity(0.9),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FluentIcons.cloud_not_synced,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "No internet connection, working locally",
                          style: FluentTheme.of(context).typography.body,
                        ),
                      ],
                    ),
                  ),
          ),
          Expanded(
            child: Container(
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
              child: ScaffoldPage.withPadding(
                padding: const EdgeInsets.all(24),
                header: const PageHeader(
                  title: Text('Scenes'),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        "Create custom scenes to suit your lifestyle and control multiple devices with just one tap. Whether it's a cozy evening at home or a lively gathering with friends, your smart home is at your command. With scenes, you can easily set the perfect ambiance for any occasion and make controlling your smart home a breeze."),
                    Lottie.asset(
                      height: 440,
                      AnimationsUtil.scenesAnimation,
                    ),
                    FilledButton(
                      onPressed: scenesController.hasInternetConnection
                          ? () async {}
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 250,
                        child: Text(
                          "Add your first scene",
                          style: TextStyle(
                              color: FluentTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
