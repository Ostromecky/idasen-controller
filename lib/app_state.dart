import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ble_controller.dart';
import 'device.dart';

class DeviceState with ChangeNotifier {
  final _positionCharacteristic = '99fa0021-338a-1024-8a49-009c0215f78a';
  final _deskControlCharacteristic = '99fa0002-338a-1024-8a49-009c0215f78a';
  final BleController _bleController;
  SharedPreferences? _sharedPreferences;
  final String _deviceIdToken = 'remoteId';
  final String _platformNameToken = 'platformName';
  final _destroy = BehaviorSubject<void>();
  final int _basePosition = 6200;

  var devices = <Device>[];
  int? currentPosition;
  Device? currentDevice;

  String get currentDeviceName {
    return (_isNullOrEmpty(currentDevice?.name)
            ? _sharedPreferences?.getString(_platformNameToken)
            : currentDevice?.name) ??
        '';
  }


  DeviceState({required BleController bleController})
      : _bleController = bleController {
    _init();
  }

  _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _bleController.init();
    _initDeviceListener();
    await _reconnect();
  }

  void _initDeviceListener() {
    _bleController.getDevice().takeUntil(_destroy).listen((device) async {
      if (device == null) {
        currentDevice = null;
        _sharedPreferences?.remove(_deviceIdToken);
        _sharedPreferences?.remove(_platformNameToken);
        notifyListeners();
        return;
      }

      currentDevice = device;

      if (device.name.isNotEmpty) {
        _sharedPreferences?.setString(_platformNameToken, device.name);
      }
      _sharedPreferences?.setString(_deviceIdToken, device.id);
      notifyListeners();
      await getCurrentHeight();
      _listenToHeight();
    });
  }

  _reconnect() async {
    var remoteId = _sharedPreferences?.getString(_deviceIdToken);
    var platformName = _sharedPreferences?.getString(_platformNameToken);

    if(!_isNullOrEmpty(platformName)) {
      notifyListeners();
    }

    print('Retrieved remoteId: $remoteId');
    print('Retrieved platformName: $platformName');

    if (remoteId == null) {
      return;
    }

    var device = _bleController.retrieveDevice(remoteId);

    if (device == null) {
      print('device is null');
      _sharedPreferences?.remove(_deviceIdToken);
      _sharedPreferences?.remove(_platformNameToken);
      return;
    }

    await connect(device);
  }

  _clearDevices() {
    devices.clear();
    notifyListeners();
  }

  connect(Device device) {
    _bleController.connect(device);
  }

  void scan() {
    _clearDevices();
    _bleController.scan().listen((results) {
      for (var device in results) {
        devices.add(device);
        notifyListeners();
      }
    }, onError: (e) {
      print('Handle error $e');
    });
  }

  moveUp() async {
    await _bleController
        .writeCharacteristics(_deskControlCharacteristic, [0x47, 0x00]);
  }

  moveDown() async {
    await _bleController
        .writeCharacteristics(_deskControlCharacteristic, [0x46, 0x00]);
  }

  getCurrentHeight() async {
    var value =
        await _bleController.readCharacteristics(_positionCharacteristic);
    currentPosition = _getPositionInCm(value);
    notifyListeners();
  }

  disconnect() async {
    await _bleController.disconnectFromDevice();
    _sharedPreferences?.remove(_deviceIdToken);
    _sharedPreferences?.remove(_platformNameToken);
    currentDevice = null;
    currentPosition = null;
    notifyListeners();
  }

  _listenToHeight() {
    _bleController
        .listenToCharacteristic(_positionCharacteristic)
        .map((value) => _getPositionInCm(value))
        .distinct()
        .takeUntil(_destroy)
        .listen((value) {
      currentPosition = value;
      notifyListeners();
    });
  }

  _numbersToNumber(List<int> value) {
    return value[0] + (value[1] << 8);
  }

  _getPositionInCm(List<int> value) {
    return ((_basePosition + _numbersToNumber(value)) / 100).floor();
  }

  @override
  void dispose() {
    _destroy.add(null);
    _destroy.close();
    super.dispose();
  }

  _isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }
}
