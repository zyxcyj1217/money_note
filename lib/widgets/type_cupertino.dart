import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypeCupertion extends StatefulWidget {
  @override
  _TypeCupertionState createState() => _TypeCupertionState();
}

class _TypeCupertionState extends State<TypeCupertion> {
  List<String> type = ['錢包', '郵局', '一通卡', '悠遊卡'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
      ),
      child: Container(
        height: 100,
        child: CupertinoPicker(
          backgroundColor: Colors.black,
          itemExtent: 50,
          onSelectedItemChanged: (int index) {},
          children: <Widget>[
            for (var i in type)
              Center(
                  child: Text(i,
                      style: TextStyle(fontSize: 30.0, color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
