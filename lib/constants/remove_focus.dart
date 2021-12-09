import 'package:flutter/cupertino.dart';

class RemoveFocus {
  late FocusScopeNode _currentFocus;

  RemoveFocus() {
     _currentFocus = FocusScopeNode();
  }

  void removeFocus(BuildContext context) {
    _currentFocus = FocusScope.of(context);
    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.requestFocus(FocusNode());
    }
  }

  void dispose() {
    _currentFocus.dispose();
  }
}
