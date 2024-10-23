import 'package:flutter/material.dart';
import 'package:idasen_controller/app_state.dart';
import 'package:idasen_controller/onboarding/welcome.dart';
import 'package:provider/provider.dart';

import 'device_state.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;

  _handlePageChange(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  _updateCurrentPageIndex(int index) {
    _pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageViewController,
        onPageChanged: _handlePageChange,
        children: <Widget>[
          WelcomeScreen(
              onButtonPressed: () =>
                  _updateCurrentPageIndex(_currentPageIndex + 1)),
          DeviceList(
              deviceState: Provider.of<DeviceState>(context),
              appState: Provider.of<AppState>(context)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }
}

class DeviceList extends StatefulWidget {
  final DeviceState _deviceState;
  final AppState _appState;

  const DeviceList({
    super.key,
    required DeviceState deviceState,
    required AppState appState,
  })  : _deviceState = deviceState,
        _appState = appState;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  @override
  void initState() {
    super.initState();
    widget._deviceState.scan();

    widget._deviceState.addListener(_deviceStateListenerCallback);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...widget._deviceState.devices.map((device) => ListTile(
              title:
                  Text(device.name != '' ? device.name : device.id.toString()),
              onTap: () => widget._deviceState.connect(device),
            ))
      ],
    );
  }

  @override
  dispose() {
    super.dispose();
    widget._deviceState.removeListener(_deviceStateListenerCallback);
  }

  _deviceStateListenerCallback() {
    if (widget._deviceState.currentDevice != null) {
      widget._appState.isFirstVisit = false;
    }
  }
}
