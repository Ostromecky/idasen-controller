import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idasen_controller/app_state.dart';
import 'package:idasen_controller/ble_controller.dart';
import 'package:idasen_controller/device.dart';
import 'package:idasen_controller/onboard_screen.dart';
import 'package:provider/provider.dart';

import 'desk_controls.dart';
import 'device_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => BleController()),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(
            create: (context) =>
                DeviceState(bleController: context.read<BleController>())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.lato(
              color: Colors.black54,
            ),
            bodyLarge: GoogleFonts.lato(
              color: Colors.black54,
            ),
            bodySmall: GoogleFonts.lato(
              color: Colors.black54,
            ),
            displaySmall: GoogleFonts.poppins(
              fontWeight: FontWeight.bold
            ),
            displayLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            labelLarge: GoogleFonts.lato(),
            labelMedium: GoogleFonts.lato(),
            labelSmall: GoogleFonts.lato(),
            titleLarge: GoogleFonts.lato(),
            titleMedium: GoogleFonts.lato(),
            titleSmall: GoogleFonts.lato(),
          ),
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
    var deviceState = context.watch<DeviceState>();
    var appState = context.watch<AppState>();

    void connect(Device device) {
      deviceState.connect(device);
    }

    return Scaffold(
      appBar: appState.firstVisit
          ? null
          : AppBar(
              title: Text(deviceState.currentDeviceName),
            ),
      body: appState.firstVisit
          ? const OnboardScreen()
          : Stack(
              // fit: StackFit.expand,
              children: [
                ListView(
                  children: [
                    ...deviceState.devices.map((device) => ListTile(
                          title: Text(device.name != ''
                              ? device.name
                              : device.id.toString()),
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
