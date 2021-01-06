import 'dart:convert';

import 'package:flutter/services.dart';

typedef OnNativeProcessor = Future Function(String args);

class MedcloudsNativeApi {
  MethodChannel _channel = MethodChannel("com.emedclouds-channel/navigation");
  Map<String, OnNativeProcessor> _map = {};

  static MedcloudsNativeApi _instance;

  MedcloudsNativeApi._() {
    print("MedcloudsNativeApi");
    _channel.setMethodCallHandler((call) async {
      if (_map.containsKey(call.method)) {
        return await _map[call.method](call.arguments);
      }
      return null;
    });
  }

  static MedcloudsNativeApi instance() {
    if (_instance == null) {
      _instance = MedcloudsNativeApi._();
    }
    return _instance;
  }

  void addProcessor(String method, OnNativeProcessor processor) {
    if (method == null) {
      print('method must be not null.');
    }
    if (processor == null) {
      print('processor must be not null.');
    }
    if (_map.containsKey(method)) {
      print('[$method] already registered');
    }
    _map[method] = processor;
  }

  Future share(String args) async {
    return await _channel.invokeMapMethod("share", args);
  }

  Future record(String args) async {
    return await _channel.invokeMapMethod("record", args);
  }

}
