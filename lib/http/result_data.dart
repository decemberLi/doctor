/// 通用请求返回结果封装
class ResultData<T> {
  final String status;
  final String errorCode;
  final String errorMsg;
  final T content;
  ResultData(this.status, this.errorCode, this.errorMsg, this.content);
  ResultData.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        errorCode = json['errorCode'],
        errorMsg = json['errorMsg'],
        content = json['content'];
}
