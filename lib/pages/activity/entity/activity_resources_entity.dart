import 'package:doctor/model/oss_file_entity.dart';

class ActivityResourceEntity {
  int activityTaskId;
  int activityPackageId;
  List<OssFileEntity> attachments;

  ActivityResourceEntity(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    activityPackageId = json['activityPackageId'];
    activityTaskId = json['activityTaskId'];
    attachments = json['attachments'] != null
        ? (json['attachments'] as List)
            .map((e) => OssFileEntity.fromJson(e))
            .toList()
        : [];
  }
}
