import 'package:doctor/common/env/environment.dart';

class UrlProvider {
  static String doctorsCircleUrl(Environment environment) {
    switch (environment.env) {
      case AppEnvironment.ENV_PROD:
        return 'https://m.e-medclouds.com/mpost/#/detail';
      case AppEnvironment.ENV_QA:
        return 'https://m-dev.e-medclouds.com/mpost/#/detail';
      case AppEnvironment.ENV_DEV:
        return 'https://m-dev.e-medclouds.com/mpost/#/detail';
    }

    throw AssertionError('environment info error.');
  }
}
