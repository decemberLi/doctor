import 'dart:collection';

import 'package:doctor/common/push/push_processor.dart';

class PushMessageDispatcher {
  PushMessageDispatcher._();

  static PushMessageDispatcher instance = PushMessageDispatcher._();

  Map<String, AbsMessageProcessor> _processorMap = Map();

  /// dispatch data struct :
  ///
  /// {\"bizType\":\"QUALIFICATION_AUTH\",\"authStatus\":\"FAIL\",\"messageId\":1,"userId":111}
  ///
  void dispatch(Map<String, dynamic> json) {
    AbsMessageProcessor processor = getProcessor(json['bizType']);
    processor.process(null, processor.getType(json));
  }

  AbsMessageProcessor getProcessor(String bizType) {
    return _processorMap[bizType];
  }

  void registerProcessor(String bizType, AbsMessageProcessor processor) {
    assert(bizType != null);
    assert(processor != null);
    _processorMap[bizType] = processor;
  }
}
