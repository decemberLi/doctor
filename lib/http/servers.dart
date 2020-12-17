enum AppEnvironment { ENV_DEV, ENV_QA, ENV_PROD }

class ApiHost {
  AppEnvironment _env;

  static ApiHost _instance;

  ApiHost._internal(AppEnvironment env) {
    if (this._env != null) {
      throw AssertionError(
          'App environment config info has already configuration');
    }
    this._env = env;
  }

  factory ApiHost.initHostByEnvironment(AppEnvironment env) {
    _instance = ApiHost._internal(env);
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
    if (_env == null) {
      throw AssertionError(
          'You must be call ApiHost.initHostByEnvironment(AppEnvironment env) init host configuration');
    }
    switch (_env) {
      case AppEnvironment.ENV_DEV:
        return 'https://gateway-dev.e-medclouds.com';
      case AppEnvironment.ENV_QA:
        return 'https://gateway-dev.e-medclouds.com';
      case AppEnvironment.ENV_PROD:
        return 'https://gateway.e-medclouds.com';
    }

    throw AssertionError('AppEnvironment config info error, env -> $_env');
  }
}
