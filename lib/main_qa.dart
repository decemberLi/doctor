import 'package:doctor/application.dart';
import 'package:doctor/http/host_provider.dart';

class ApplicationEnvQAConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_QA;

}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvQAConfig());
}
