import 'package:doctor/model/oss_file_entity.dart';

class ActivityResourceEntity {
  int activityTaskId;
  int activityPackageId;
  String rejectReason;
  String status;
  List<OssFileEntity> attachments;

  ActivityResourceEntity(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    activityPackageId = json['activityPackageId'];
    status = json['status'];
    rejectReason = json['rejectReason'];
    activityTaskId = json['activityTaskId'];
    attachments = json['attachments'] != null
        ? (json['attachments'] as List)
            .map((e) => OssFileEntity.fromJson(e))
            .toList()
        : [];
  }
}
