library persistent_top_sheet;

import 'package:flutter/material.dart';

/// The controller that can be used to open, close, or toggle the top sheet.
class PersistentTopSheetController extends ChangeNotifier {
  bool _isOpen = false;

  /// Whether the top sheet is open.
  bool get isOpen => _isOpen;

  /// Opens the top sheet.
  void open() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Closes the top sheet.
  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  /// Toggles the top sheet (opens if closed, closes if open).
  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }
}
