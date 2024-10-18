import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rxdart/rxdart.dart';

class Device {
  final BluetoothDevice _device;
  String name;
  String id;
  List<BluetoothService>? _services;

  Device(this._device)
      : name = _device.platformName,
        id = _device.remoteId.toString();

  Future<void> _initServices() async {
    _services = await _device.discoverServices();
  }

  getServices() {
    return _services;
  }

  getService(String uuid) {
    return _services?.firstWhere((element) => element.uuid.toString() == uuid);
  }

  BluetoothCharacteristic? getCharacteristic(String uuid) {
    return _services
        ?.expand((element) => element.characteristics)
        .firstWhere((element) => element.uuid.toString() == uuid);
  }

  Stream<Device?> connect({bool autoConnect = false, int? mtu}) {
    var devSubject = BehaviorSubject<Device?>();

    _device
        .connect(autoConnect: autoConnect, mtu: mtu)
        .asStream()
        .switchMap((e) => _device.connectionState
            .where((val) => val == BluetoothConnectionState.connected)
            .switchMap((e) => _initServices().asStream()))
        .doOnData((event) {
          devSubject.add(this);
        })
        .take(1)
        .listen(null);
    return devSubject.stream;
  }

  disconnect() async {
    await _device.disconnect();
  }

  static fromId(String id) {
    var dev = BluetoothDevice.fromId(id);
    return Device(dev);
  }
}
