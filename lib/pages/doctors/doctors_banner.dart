
import 'package:flutter/material.dart';

class DoctorsBanner extends StatelessWidget {
  final List dataList;
  DoctorsBanner(this.dataList);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 237,
      child: PageView(
        children: [
          Container(color: Colors.blue,),
          Container(color: Colors.black,),
          Container(color: Colors.yellow,)
        ],
      ),
    );
  }

  Widget page(){
    return Container(

    );
  }

}