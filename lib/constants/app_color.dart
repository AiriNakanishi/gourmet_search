import 'dart:ui';

class AppColor {
  // ignore: library_private_types_in_public_api
  static final _Brand brand = _Brand();
  // ignore: library_private_types_in_public_api
  static final _Text text = _Text();
  // ignore: library_private_types_in_public_api
  static final _Ui ui = _Ui();
}

class _Brand {
  final Color primary = const Color(0xFFFFFFFF);
  final Color secondary = const Color(0xFFff69b4);
}

class _Text {
  final Color primary = const Color(0xFF373737);
  final Color secondary = const Color(0xFFff69b4);
  final Color gray = const Color(0xFF808080);
  final Color white = const Color(0xFFFFFFFF);
  final Color darkgray = const Color(0xFF404040);
}

class _Ui {
  final Color primary = const Color(0xFFff69b4);
  final Color lightPink = const Color(0XFFF7ADC3);
  final Color white = const Color(0xFFFFFFFF);
  final Color black = const Color(0xFF373737);
  final Color gray = const Color(0xFF808080);
}
