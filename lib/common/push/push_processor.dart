import 'dart:html';

import 'package:doctor/common/push/entity/push_message_entity.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/cupertino.dart';

abstract class AbsMessageProcessor<T> {
  Future process(BuildContext context, T param);

  T getType(json);
}

class QualificationMessageProcessor
    extends AbsMessageProcessor<QualificationMessageEntity> {
  @override
  Future process(BuildContext context, QualificationMessageEntity param) {
    if (param.authStatus == "FAIL") {
      return Navigator.of(context)
          .pushNamed(RouteManager.DOCTOR_AUTHENTICATION_PAGE);
    } else {
      return Navigator.of(context)
          .pushNamed(RouteManager.DOCTOR_AUTH_STATUS_PASS_PAGE);
    }
  }

  @override
  QualificationMessageEntity getType(json) => QualificationMessageEntity(json);
}

class LearnPlanMessageProcessor
    extends AbsMessageProcessor<LearnPlanMessageEntity> {
  @override
  Future process(BuildContext context, LearnPlanMessageEntity param) {
    // TODO: implement process
  }

  @override
  LearnPlanMessageEntity getType(json) => LearnPlanMessageEntity(json);
}

class ActivityMessageProcessor
    extends AbsMessageProcessor<ActivityMessageEntity> {
  @override
  Future process(BuildContext context, ActivityMessageEntity param) {
    // TODO: implement process
  }

  @override
  ActivityMessageEntity getType(json) => ActivityMessageEntity(json);
}
