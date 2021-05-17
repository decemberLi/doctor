import 'package:doctor/common/push/entity/push_message_entity.dart';
import 'package:doctor/common/push/push_processor.dart';
import 'package:flutter/cupertino.dart';

class PushMessageDispatcher {
  PushMessageDispatcher._();

  static PushMessageDispatcher instance = PushMessageDispatcher._();

  Map<String, AbsMessageProcessor> _processorMap = Map();

  /// dispatch data struct :
  ///
  /// {\"bizType\":\"QUALIFICATION_AUTH\",\"authStatus\":\"FAIL\",\"messageId\":1,"userId":111}
  ///
  void dispatch(BuildContext context, Map<String, dynamic> json) {
    var entity = MessageEntity(json);
    AbsMessageProcessor processor = getProcessor(entity.bizType);
    // 强制定义数据实体结构，避免使用 object['key'] 方式取值
    processor.process(context, processor.getType(entity.data));
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
