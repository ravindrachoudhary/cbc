import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:device_info_plus/device_info_plus.dart';

class DeviceId {
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static Map<String, dynamic> deviceDetails = <String, dynamic>{};
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'id': data.id,
    'deviceId': data.machineId,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'userName': data.hostName,
    'deviceId': data.systemGUID,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'userName': data.userName,
    'deviceId': data.deviceId,
  };
}

Future<void> initPlatformState(StateSetter setState, var mounted) async {
  var deviceData = <String, dynamic>{};

  try {
    if (Platform.isLinux) {
      deviceData =
          _readLinuxDeviceInfo(await DeviceId.deviceInfoPlugin.linuxInfo);
    } else if (Platform.isMacOS) {
      deviceData =
          _readMacOsDeviceInfo(await DeviceId.deviceInfoPlugin.macOsInfo);
    } else if (Platform.isWindows) {
      deviceData =
          _readWindowsDeviceInfo(await DeviceId.deviceInfoPlugin.windowsInfo);
    }
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }

  if (!mounted) return;

  setState(() {
    DeviceId.deviceDetails = deviceData;
  });
}
