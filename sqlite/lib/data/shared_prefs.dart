import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SPSettings {
  final String fontSizeKey = 'font_size';
  final String colorKey = 'color';
  static late SharedPreferences _sp; //private instance of SharedPreferences

  //istanza statica della classe stessa  Può essere null ma dobbiamo essere sicuri di settarla
  static SPSettings? _instance;

  //a private named constructor called internal
  SPSettings._internal();

  //A unnamed constructor  with a factory keyword
  factory SPSettings() {
    _instance ??= SPSettings._internal();

    return _instance as SPSettings;
  }

  Future init() async {
    _sp = await SharedPreferences.getInstance();
  }

  Future setColor(int color) {
    return _sp.setInt(colorKey, color);
  }

  int getColor() {
    int? color = _sp.getInt(colorKey);
    color ??= 0xFF454A64;

    /*
      ?? equivasle a 
      if (color == null) {
          color = 0xff1976d2;
      }
    */
    return color;
  }

  Future setFontSize(double size) {
    return _sp.setDouble(fontSizeKey, size);
  }

  double getFontSize() {
    double? fontSize = _sp.getDouble(fontSizeKey);
    fontSize ??= 14; //Default
    return fontSize;
  }
}
