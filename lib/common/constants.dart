import 'package:doctor/http/host_provider.dart';

const String userAgreement = '/web/other/protocols/doctor_license_app.html';
const String privacyAgreement = '/web/other/protocols/doctor_privacy_app.html';

processPrivacyAgreementHost() {
  if (ApiHost.instance.enableCNHost) {
    return 'https://static.e-medclouds.com.cn$privacyAgreement';
  }

  return 'https://static.e-medclouds.com$privacyAgreement';
}

processUserAgreementHost() {
  if (ApiHost.instance.enableCNHost) {
    return 'https://static.e-medclouds.com.cn$userAgreement';
  }

  return 'https://static.e-medclouds.com$userAgreement';
}
