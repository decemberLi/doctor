


class CloudAgreement{
  String title;
  String agreement;

  CloudAgreement(Map<String, dynamic> json){
    this.title = json['title']as String;
    this.agreement = json['agreement'] as String;
  }

}