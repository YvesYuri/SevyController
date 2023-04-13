import 'package:controller/src/data/utils/images_util.dart';

class DevicesIconsUtil {
  static const String ssw100Icon = ImagesUtil.lamp;

  String getDeviceIcon(String model) {
    switch (model) {
      case 'SSW-100':
        return ssw100Icon;
      default:
        return ssw100Icon;
    }
  }
}