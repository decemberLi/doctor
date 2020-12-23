import 'package:doctor/application.dart';

import 'common/env/environment.dart';

class ApplicationEnvProdConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_PROD;
}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvProdConfig());
}
