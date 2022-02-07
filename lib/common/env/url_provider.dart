import 'package:doctor/common/env/environment.dart';
import 'package:doctor/http/host_provider.dart';

class UrlProvider {
  static _getDotCnIfNeeded(){
    return '';
  }

  static String doctorsCircleUrl(Environment environment) {
    switch (environment.env) {
      case AppEnvironment.ENV_PROD:
        return 'https://m.e-medclouds.com${_getDotCnIfNeeded()}/mpost/#/detail';
      case AppEnvironment.ENV_QA:
        return 'https://m-dev.e-medclouds.com${_getDotCnIfNeeded()}/mpost/#/detail';
      case AppEnvironment.ENV_DEV:
        return 'https://m-dev.e-medclouds.com${_getDotCnIfNeeded()}/mpost/#/detail';
    }

    throw AssertionError('environment info error.');
  }

  static String mHost(Environment environment){
    switch (environment.env) {
      case AppEnvironment.ENV_PROD:
        return 'https://m.e-medclouds.com${_getDotCnIfNeeded()}/';
      case AppEnvironment.ENV_QA:
        return 'https://m-dev.e-medclouds.com${_getDotCnIfNeeded()}/';
      case AppEnvironment.ENV_DEV:
        return 'https://m-dev.e-medclouds.com${_getDotCnIfNeeded()}/';
    }

    throw AssertionError('environment info error.');
  }
}
