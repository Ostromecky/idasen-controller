import 'package:flutter/widgets.dart';

import '../desk_controls.dart';

class ControllerScreen extends StatelessWidget {
  const ControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(fit: StackFit.expand, children: [DeskControls()]);
  }
}
