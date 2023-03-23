import 'package:controller/src/modules/settings/settings_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Settings'),
      ),
      // padding: const EdgeInsets.all(
      //   10,
      // ),
      content: Consumer<SettingsController>(
          builder: (context, settingsController, child) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'Theme mode',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(
                height: 10,
              ),
              RadioButton(
                checked: settingsController.themeMode == ThemeMode.system,
                content: const Text('System'),
                onChanged: (checked) {
                  settingsController.changeThemeMode(ThemeMode.system);
                },
              ),
              const SizedBox(
                height: 7,
              ),
              RadioButton(
                checked: settingsController.themeMode == ThemeMode.light,
                content: const Text('Light'),
                onChanged: (checked) {
                  settingsController.changeThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(
                height: 7,
              ),
              RadioButton(
                checked: settingsController.themeMode == ThemeMode.dark,
                content: const Text('Dark'),
                onChanged: (checked) {
                  settingsController.changeThemeMode(ThemeMode.dark);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Language',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(
                height: 10,
              ),
              RadioButton(
                checked: true,
                content: const Text('English'),
                onChanged: (checked) {},
              ),
              const SizedBox(
                height: 7,
              ),
              RadioButton(
                checked: false,
                content: const Text('Portuguese'),
                onChanged: (checked) {},
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Cloud Sync',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(
                height: 10,
              ),
              RadioButton(
                checked: true,
                content: const Text('Enable'),
                onChanged: (checked) {},
              ),
              const SizedBox(
                height: 7,
              ),
              RadioButton(
                checked: false,
                content: const Text('Disabled'),
                onChanged: (checked) {},
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Accent color',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(
                height: 10,
              ),
              RadioButton(
                checked: settingsController.accentColor ==
                    SystemTheme.accentColor.accent.toAccentColor(),
                content: const Text('System'),
                onChanged: (checked) {
                  settingsController.changeAccentColor(
                    SystemTheme.accentColor.accent.toAccentColor(),
                  );
                },
              ),
              const SizedBox(
                height: 7,
              ),
              RadioButton(
                checked: Colors.accentColors.any(
                    (element) => element == settingsController.accentColor),
                content: SizedBox(
                  height: 20,
                  child: ListView.builder(
                    itemCount: Colors.accentColors.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final color = Colors.accentColors[index];
                      return Tooltip(
                        message: [
                          'Yellow',
                          'Orange',
                          'Red',
                          'Magenta',
                          'Purple',
                          'Blue',
                          'Teal',
                          'Green',
                        ][index],
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 4,
                          ),
                          child: Button(
                            onPressed: () {
                              settingsController.changeAccentColor(color);
                            },
                            style: ButtonStyle(
                              padding: ButtonState.all(EdgeInsets.zero),
                              backgroundColor:
                                  ButtonState.resolveWith((states) {
                                if (states.isPressing) {
                                  return color.light;
                                } else if (states.isHovering) {
                                  return color.lighter;
                                }
                                return color;
                              }),
                            ),
                            child: Container(
                              height: 20,
                              width: 20,
                              alignment: AlignmentDirectional.center,
                              child: settingsController.accentColor == color
                                  ? Icon(
                                      FluentIcons.check_mark,
                                      color: color.basedOnLuminance(),
                                      size: 12,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onChanged: (checked) {
                  settingsController.changeAccentColor(
                    Colors.accentColors.first,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }),
    );
  }
}
