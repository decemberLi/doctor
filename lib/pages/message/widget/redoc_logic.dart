import 'package:doctor/pages/message/model/social_message_entity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

buildMessageItemAvatar(SocialMessageModel data) {
  return Container(
    child: Stack(
      overflow: Overflow.visible,
      children: [
        data?.postType == 'GOSSIP'
            ? _buildGossipAvatar(data?.messageTitle ?? '')
            : _buildUserAvatar(data?.sendUserHeader),
        Positioned(
            right: 8,
            top: -3,
            child: Container(
              decoration: BoxDecoration(
                  color: data.readed ?? true ? Colors.transparent : Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
            ))
      ],
    ),
  );
}

_buildUserAvatar(String url) {
  ImageProvider imageProvider;
  if (url != null) {
    imageProvider = NetworkImage(url);
  } else {
    imageProvider = AssetImage('assets/images/doctorAva.png');
  }
  return Container(
    width: 40,
    height: 40,
    margin: EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
        border: new Border.all(color: ThemeColor.colorFFB8D1E2, width: 2),
        color: ThemeColor.colorFFF3F5F8,
        borderRadius: new BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          // fit: BoxFit.fill,
          fit: BoxFit.fitWidth,
          image: imageProvider,
        )),
  );
}

_buildGossipAvatar(String name) {
  if (name == null) {
    print('发帖人为空');
    return Container();
  }
  var firstText = name.substring(0, 1);
  return Container(
    margin: EdgeInsets.only(right: 12),
    alignment: Alignment.center,
    width: 40,
    height: 40,
    decoration: BoxDecoration(
        color: ThemeColor.colorFFf25CDA1,
        borderRadius: BorderRadius.circular(20)),
    child: Text(
      firstText,
      style: TextStyle(fontSize: 24, color: ThemeColor.colorFFFFFF),
    ),
  );
}
