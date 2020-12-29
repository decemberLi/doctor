enum AppEnvironment { ENV_DEV, ENV_QA, ENV_PROD }

class Environment {
  AppEnvironment _env;

  static Environment _instance;

  Environment._(AppEnvironment env) {
    if (this._env != null) {
      throw AssertionError(
          'App environment config info has already configuration');
    }
    this._env = env;
  }

  AppEnvironment get env => _env;

  factory Environment.initEnv(AppEnvironment env) {
    _instance = Environment._(env);
    return _instance;
  }

  static Environment get instance {
    if (_instance == null) {
      throw AssertionError(
          'You must be call Environment.env(AppEnvironment env) init Env configuration');
    }
    return _instance;
  }
}
