import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_top_sheet/persistent_top_sheet.dart';

void main() {
  test('controller state after open/close', () {
    final controller = PersistentTopSheetController();
    controller.open();
    expect(controller.isOpen, true);

    controller.close();
    expect(controller.isOpen, false);
  });
}
