import 'package:doctor/application.dart';
import 'package:doctor/http/servers.dart';

class ApplicationEnvProdConfig with ApplicationInitializeConfigMixin {
  @override
  AppEnvironment get env => AppEnvironment.ENV_PROD;
}

void main() async {
  ApplicationInitialize.initialize(ApplicationEnvProdConfig());
}
