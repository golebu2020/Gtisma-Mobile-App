


import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInformation{
  String deviceID;
  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceID = build.androidId; //UUID of the device
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        deviceID = build.identifierForVendor; //UUID of the device
      }
    } on PlatformException{
      print('Failed to get platform version');
    }
    return deviceID;
  }
}

//usage: String deviceID = await getDeviceInfo();