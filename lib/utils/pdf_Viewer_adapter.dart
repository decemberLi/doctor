import 'dart:convert';

import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/platform_utils.dart';

class PdfViewerAdapter {
  static Future openFile(String url,
      {Function onLoadingFinished, String title = ''}) async {
    if (Platform.isIOS) {
      return await MedcloudsNativeApi.instance().openWebPage(url, title: title);
    }
    return await MedcloudsNativeApi.instance().openFile(url, title: title);
  }
}
