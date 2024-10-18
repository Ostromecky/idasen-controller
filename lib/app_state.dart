import 'package:flutter/widgets.dart';

class AppState extends ChangeNotifier {
  var _isFirstVisit = true;

  bool get firstVisit => _isFirstVisit;

  set firstVisit(bool value) {
    _isFirstVisit = value;
    notifyListeners();
  }
}
