import 'package:flutter/material.dart';
import 'package:persistent_top_sheet/persistent_top_sheet.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTopSheetController controller = PersistentTopSheetController();

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: controller.open,
                child: const Text('Open Top Sheet'),
              ),
            ),
            PersistentTopSheet(
              controller: controller,
              child: Container(
                color: Colors.amber,
                child: ListTile(
                  title: const Text('Persistent Top Sheet'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.close,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
