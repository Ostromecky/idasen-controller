import 'package:flutter/material.dart';
import 'package:idasen_controller/ble_controller.dart';
import 'package:idasen_controller/device.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'desk_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceState(bleController: BleController()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<DeviceState>();

    void connect(Device device) {
      appState.connect(device);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.currentDeviceName),
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: [
          ListView(
            children: [
              ...appState.devices.map((device) => ListTile(
                    title: Text(
                        device.name != '' ? device.name : device.id.toString()),
                    onTap: () => connect(device),
                  ))
            ],
          ),
          const DeskControls()
        ],
      ),
    );
  }
}
