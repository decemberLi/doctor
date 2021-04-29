
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QRCodePageState();
  }

}
class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _canScan = true;
  QRViewController _qrViewController;
  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      appBar: AppBar(title: Text("扫描"),),
      body: Container(
        color: Colors.black,
        child: QRView(
          key: qrKey,
          onQRViewCreated: (controller) {
            _qrViewController = controller;
            var onSub = (Barcode event) async {
              if (!_canScan) {
                return;
              }
              _canScan = false;
              var content = event.code ?? "";
              Navigator.of(context).pop();
              MedcloudsNativeApi.instance().openWebPage(content);
            };
            controller.scannedDataStream.listen(onSub);
          },
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
        ),
      ),
    );
  }
}