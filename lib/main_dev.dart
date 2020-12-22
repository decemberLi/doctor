import 'package:doctor/application.dart';

import 'common/env/environment.dart';

class ApplicationEnvDevConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_DEV;
}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvDevConfig());
}
