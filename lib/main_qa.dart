import 'package:doctor/application.dart';
import 'package:doctor/http/servers.dart';

class ApplicationEnvQAConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_QA;

}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvQAConfig());
}
