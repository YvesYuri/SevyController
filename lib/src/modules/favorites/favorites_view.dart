import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/services/database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../data/utils/animations_util.dart';
import 'favorites_controller.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    var favoritesController =
        Provider.of<FavoritesController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      favoritesController.getConnectivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesController>(
        builder: (context, favoritesController, child) {
      return Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: favoritesController.hasInternetConnection
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
                  title: Text('Favorites'),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        "Welcome to your smart home favorites page! Here, you can choose your most frequently used devices for quick and easy access. From turning on the lights to adjusting the temperature, your favorite devices are just a tap away. Customize your favorites list to fit your unique lifestyle and enjoy effortless control of your smart home."),
                    Lottie.asset(
                      height: 420,
                      AnimationsUtil.favoritesAnimation,
                    ),
                    FilledButton(
                      onPressed: favoritesController.hasInternetConnection
                          ? () async {}
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 200,
                        child: Text(
                          "Chose favorites",
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
