import 'package:doctor/application.dart';
import 'package:doctor/http/host_provider.dart';

class ApplicationEnvDevConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_DEV;
}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvDevConfig());
}
