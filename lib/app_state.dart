import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final String _firstVisitToken = 'firstVisit';
  late SharedPreferences _sharedPreferences;
  late bool _isFirstVisit = true;

  AppState() {
    _init();
  }

  bool get isFirstVisit => _isFirstVisit;

  set isFirstVisit(bool value) {
    _isFirstVisit = value;
    _sharedPreferences.setBool(_firstVisitToken, value);
    notifyListeners();
  }

  _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _isFirstVisit = _sharedPreferences.getBool(_firstVisitToken) ?? true;
    notifyListeners();
  }
}
