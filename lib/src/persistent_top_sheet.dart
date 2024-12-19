library persistent_top_sheet;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:persistent_top_sheet/src/persistent_top_sheet_controller.dart';

class PersistentTopSheet extends StatefulWidget {
  const PersistentTopSheet({
    super.key,
    required this.child,
    this.controller,
    this.speed = 2000,
  });

  final Widget child;
  final PersistentTopSheetController? controller;
  final double speed;

  @override
  State<PersistentTopSheet> createState() => _PersistentTopSheetState();
}

class _PersistentTopSheetState extends State<PersistentTopSheet> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> anim;
  late PersistentTopSheetController controller;

  double height = 300;

  double kDraggerSize = kMinInteractiveDimension + 10;

  double get minHeight => kToolbarHeight + (MediaQuery.of(context).padding.top < 50 ? 16 : 0);
  double get maxHeight => MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - kDraggerSize;

  double get draggerPaddingBottom => max(0, (MediaQuery.of(context).padding.bottom * (max(0, currentHeight - maxHeight / 2) / (maxHeight / 2))));

  double get currentHeight => max(minHeight, height);

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? PersistentTopSheetController();
    animController = AnimationController(vsync: this);

    animController.addListener(() => setState(() => height = anim.value));

    controller.addListener(onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChanged);
    animController.dispose();

    super.dispose();
  }

  void onControllerChanged() {
    if (controller.isOpen) {
      open();
    } else {
      close();
    }
  }

  Future<void> _runAnimation(double targetHeight, Offset pixelsPerSecond) async {
    anim = animController.drive(
      Tween<double>(
        begin: currentHeight,
        end: targetHeight,
      ),
    );

    final unitVelocity = pixelsPerSecond.dy / maxHeight;

    const spring = SpringDescription(
      mass: 40,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    await animController.animateWith(simulation);
  }

  Future<void> open({Offset? pixelsPerSecond}) {
    if (!context.mounted) return Future.value();
    return _runAnimation(maxHeight, pixelsPerSecond ?? Offset(0, widget.speed));
  }

  Future<void> close({Offset? pixelsPerSecond}) async {
    if (!context.mounted) return Future.value();

    await _runAnimation(minHeight, pixelsPerSecond ?? Offset(0, -widget.speed));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular((currentHeight - maxHeight).abs() < 5 ? 0 : 32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(currentHeight / maxHeight),
                BlendMode.modulate,
              ),
              child: SizedBox(
                height: currentHeight,
                child: Container(
                  margin: EdgeInsets.only(top: kToolbarHeight + 8 + (MediaQuery.of(context).padding.top < 50 ? 16 : 0)),
                  child: widget.child,
                ),
              ),
            ),
            // buildDraggable(contentType, context),
            SizedBox(height: draggerPaddingBottom),
          ],
        ),
      ),
    );
  }
}
