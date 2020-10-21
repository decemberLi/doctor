class DoctorInfoEntity {
  /// 姓名
  String doctorName;
  /// 手机号
  String doctorMobile;
  /// 医院名称
  String hospitalName;
  /// 医院 code
  String hospitalCode;
  /// 科室名称
  String departmentsName;
  /// 科室 code
  String departmentsCode;
  /// 职称名称
  String jobGradeName;
  /// 职称 code
  String jobGradeCode;
  /// 医生用户 ID
  int doctorUserId;
  /// 医生 ID
  int doctorId;

  DoctorInfoEntity(
      this.doctorName,
      this.doctorMobile,
      this.hospitalName,
      this.hospitalCode,
      this.departmentsName,
      this.departmentsCode,
      this.jobGradeName,
      this.jobGradeCode,
      this.doctorUserId,
      this.doctorId);

  DoctorInfoEntity.fromJson(Map<String, dynamic> json)
      : doctorName = json['doctorName'],
        doctorMobile = json['doctorMobile'],
        hospitalName = json['hospitalName'],
        hospitalCode = json['hospitalCode'],
        departmentsName = json['departmentsName'],
        departmentsCode = json['departmentsCode'],
        jobGradeName = json['jobGradeName'],
        jobGradeCode = json['jobGradeCode'],
        doctorUserId = json['doctorUserId'],
        doctorId = json['doctorId'];
}
