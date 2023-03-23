import 'package:controller/src/data/model/building_model.dart';
import 'package:controller/src/data/services/database_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

import '../../data/utils/animations_util.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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
              child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 200,
                  child: const Text("Chose favorites")),
              onPressed: () async {
                DatabaseService.instance.createBuilding(BuildingModel(
                  cover: "fasefsef",
                  name: "drererer3e",
                  id: "sdasdasd",
                  owner: "dawdaw",
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
