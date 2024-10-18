import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rxdart/rxdart.dart';

import 'device.dart';

class BleController {
  final BehaviorSubject<Device?> _connectedDeviceSubject =
      BehaviorSubject<Device?>();
  bool _isEnabled = false;

  Stream<List<Device>> scan({int duration = 10}) {
    if (!_isEnabled) {
      return Stream.error('Bluetooth is not enabled');
    }
    FlutterBluePlus.startScan(timeout: Duration(seconds: duration));

    return FlutterBluePlus.onScanResults.map((results) {
      List<Device> devices = [];
      if (results.isEmpty) {
        return [] as List<Device>;
      }
      ScanResult r = results.last;

      devices.add(Device(r.device));

      return devices;
    }).doOnData((data) {
      print('Scanning for devices $data');
    }).takeUntil(TimerStream(null, Duration(seconds: duration)));
  }

  init() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    Set<BluetoothAdapterState> inProgress = {
      BluetoothAdapterState.unknown,
      BluetoothAdapterState.turningOn
    };
    var adapterState = FlutterBluePlus.adapterState
        .where((v) => !inProgress.contains(v))
        .first;
    await adapterState
        .timeout(const Duration(seconds: 3))
        .onError((error, stackTrace) {
      throw Exception(
          "Could not determine Bluetooth state. ${FlutterBluePlus.adapterStateNow}");
    });

    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      throw Exception(
          "Bluetooth Is Not On. ${FlutterBluePlus.adapterStateNow}");
    }
  }

  void connect(Device device) {
    device.connect(autoConnect: true, mtu: null).listen((device) {
      _connectedDeviceSubject.add(device);
      print('Connected to: ${_connectedDeviceSubject.value?.id.toString()}');
      print(
          'Platform name od device: ${_connectedDeviceSubject.value?.name.toString()}');
    }, onError: (error) {
      print('Error connecting to device: $error');
      _connectedDeviceSubject.add(null);
    });
  }

  Stream<Device?> getDevice() {
    return _connectedDeviceSubject.stream;
  }

  Device? retrieveDevice(String remoteId) {
    Device? device;
    try {
      device = Device.fromId(remoteId);
      print('Retrieved device: ${device?.id}');
    } catch (e) {
      print('Error retrieve device $e');
    }
    return device;
  }

  disconnectFromDevice() async {
    await _connectedDeviceSubject.value?.disconnect();
    _connectedDeviceSubject.add(null);
  }

  Future<void> writeCharacteristics(String uuid, List<int> data) async {
    if (_connectedDeviceSubject.valueOrNull == null) {
      throw Exception('No connected device');
    }

    var char = _connectedDeviceSubject.value!.getCharacteristic(uuid);
    await char?.write(data).onError((error, stackTrace) {
      throw Exception('Error writing to characteristic: $error');
    });
  }

  Future<dynamic> readCharacteristics(String uuid) async {
    if (_connectedDeviceSubject.valueOrNull == null) {
      throw Exception('No connected device');
    }
    var char = _connectedDeviceSubject.value!.getCharacteristic(uuid);
    print('Reading from characteristic: ${char.toString()}');
    return await char?.read().onError((error, stackTrace) {
      throw Exception('Error reading from characteristic: $error');
    });
  }

  Stream<List<int>> listenToCharacteristic(String uuid) {
    var char = _connectedDeviceSubject.value?.getCharacteristic(uuid);
    return char!
        .setNotifyValue(true)
        .asStream()
        .switchMap((e) => char.onValueReceived);
  }
}
