import 'package:doctor/http/host_provider.dart';

const String userAgreement = '/web/other/protocols/doctor_license_app.html';
const String privacyAgreement = '/web/other/protocols/doctor_privacy_app.html';
const String partnerAgreement = '/web/other/protocols/license_partner.html';

_host() {
  return 'https://static.e-medclouds.com';
}

processPrivacyAgreementHost() => '${_host()}$privacyAgreement';

processUserAgreementHost() => '${_host()}$userAgreement';

processPartnerHost() => '${_host()}$partnerAgreement';
