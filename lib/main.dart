import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idasen_controller/app_state.dart';
import 'package:idasen_controller/ble_controller.dart';
import 'package:idasen_controller/screens/controller_screen.dart';
import 'package:provider/provider.dart';

import 'bottom_bar.dart';
import 'device_state.dart';
import 'onboard_screen.dart';

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
            displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, Widget>> _pages = [
    {
      'page': const ControllerScreen(),
    },
    {
      'page': const Scaffold(
        body: Center(
          child: Text('Page 2'),
        ),
      ),
    },
    {
      'page': const Scaffold(
        body: Center(
          child: Text('Page 3'),
        ),
      ),
    },
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return appState.isFirstVisit
        ? const Scaffold(
            body: OnboardScreen(),
          )
        : Scaffold(
            appBar: AppBar(
                title: Consumer<DeviceState>(
                    builder: (_, deviceState, __) =>
                        Text(deviceState.currentDeviceName)),
                bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(4.0),
                    child: DeviceStatus())),
            body: _pages[_selectedIndex]['page']!,
            floatingActionButton: FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                print('index: $index');
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                NavItem(
                  icon: Icons.message_outlined,
                ),
                const SizedBox(width: 80),
                NavItem(
                  icon: Icons.person_outline,
                ),
              ],
            ),
          );
  }
}

class DeviceStatus extends StatelessWidget {
  const DeviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceState>(
        builder: (_, deviceState, __) => Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: deviceState.connected ? Colors.green : Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(deviceState.connected ? 'Active' : 'Non-Active'),
              ],
            ));
  }
}
