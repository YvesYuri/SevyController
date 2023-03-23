import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';

import '../../data/utils/animations_util.dart';

class ScenesView extends StatefulWidget {
  const ScenesView({super.key});

  @override
  State<ScenesView> createState() => _ScenesViewState();
}

class _ScenesViewState extends State<ScenesView> {
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
              child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 250,
                  child: const Text("Add your first scene")),
              onPressed: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
