import 'package:flutter/material.dart';
import 'package:hold_down_button/hold_down_button.dart';
import 'package:idasen_controller/counter_text.dart';
import 'package:provider/provider.dart';

import 'device_state.dart';

class DeskControls extends StatelessWidget {
  const DeskControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceState>(builder: (context, deviceState, child) {
      return Positioned(
        bottom: 16,
        right: 16,
        child: Column(
          children: [
            deviceState.currentPosition == null
                ? const SizedBox(height: 24)
                : Text.rich(TextSpan(
                    text: '',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      WidgetSpan(
                        child: CounterText(
                          value: deviceState.currentPosition!,
                          initValue: 0,
                          duration: const Duration(milliseconds: 200),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextSpan(
                        text: 'cm',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )),
            const SizedBox(height: 16),
            HoldDownButton(
              onHoldDown: () async {
                await deviceState.moveUp();
              },
              holdWait: const Duration(milliseconds: 750),
              longWait: const Duration(milliseconds: 750),
              middleWait: const Duration(milliseconds: 750),
              minWait: const Duration(milliseconds: 750),
              child: FloatingActionButton.small(
                onPressed: () async {
                  await deviceState.moveUp();
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 4),
            HoldDownButton(
              onHoldDown: () async {
                await deviceState.moveDown();
              },
              holdWait: const Duration(milliseconds: 100),
              longWait: const Duration(milliseconds: 750),
              middleWait: const Duration(milliseconds: 750),
              minWait: const Duration(milliseconds: 750),
              child: FloatingActionButton.small(
                onPressed: () async {
                  await deviceState.moveDown();
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.remove),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
