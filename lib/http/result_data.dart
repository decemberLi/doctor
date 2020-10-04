class ResultData {
  final String status;
  final String errorCode;
  final String errorMsg;
  final dynamic content;
  ResultData(this.status, this.errorCode, this.errorMsg, this.content);
  ResultData.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        errorCode = json['errorCode'],
        errorMsg = json['errorMsg'],
        content = json['content'];
}
