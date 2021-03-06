import 'package:doctor/application.dart';

import 'common/env/environment.dart';

class ApplicationEnvQAConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_QA;

}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvQAConfig());
}
