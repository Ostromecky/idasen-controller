import 'package:flutter/material.dart';
import 'package:hold_down_button/hold_down_button.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

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
                : Text('${deviceState.currentPosition} cm',
                    style: Theme.of(context).textTheme.titleLarge),
            FloatingActionButton.small(
              onPressed: () {
                deviceState.scan();
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.refresh),
            ),
            // FloatingActionButton.small(onPressed: () {
            //   deviceState.disconnect();
            // },
            //   shape: const CircleBorder(),
            //   child: const Icon(Icons.bluetooth_disabled),
            // ),
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
            const SizedBox(height: 48),
          ],
        ),
      );
    });
  }
}
