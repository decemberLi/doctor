import 'package:common_utils/common_utils.dart';
import 'package:doctor/common/env/environment.dart';

class ApiHost {
  static ApiHost _instance;
  Environment _environment;
  bool enableCNHost = false;

  ApiHost._internal(Environment environment) {
    if (Environment.instance.env == null) {
      throw AssertionError('App environment config not config');
    }
    _environment = environment;
  }

  factory ApiHost.initHostByEnvironment(Environment environment) {
    _instance = ApiHost._internal(environment);
    return _instance;
  }

  static ApiHost get instance {
    if (_instance == null) {
      throw AssertionError(
          'You must be call ApiHost.initHostByEnvironment(AppEnvironment env) init host configuration');
    }
    return _instance;
  }

  String get apiHost {
    if (enableCNHost) {
      String host() {
        switch (_environment.env) {
          case AppEnvironment.ENV_DEV:
            return 'http://gateway-dev.e-medclouds.com.cn';
          case AppEnvironment.ENV_QA:
            return 'http://gateway-dev.e-medclouds.com';
          case AppEnvironment.ENV_PROD:
            return 'https://gateway.e-medclouds.com.cn';
        }
        throw AssertionError(
            'AppEnvironment config info error, env -> ${_environment.env}');
      }
    }

    return host();
  }

  String host() {
    switch (_environment.env) {
      case AppEnvironment.ENV_DEV:
        return 'https://gateway-dev.e-medclouds.com';
      case AppEnvironment.ENV_QA:
        return 'https://gateway-dev.e-medclouds.com';
      case AppEnvironment.ENV_PROD:
        return 'https://gateway.e-medclouds.com';
    }

    throw AssertionError(
        'AppEnvironment config info error, env -> ${_environment.env}');
  }
}
