import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_note/page_add.dart';
import 'package:money_note/page_home.dart';

var _pc = PageController(initialPage: 0);

void jumpPage(var index) {
  _pc.animateToPage(index, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
}

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  StatefulWidget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return AddPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent)); // statusBar 設置為透明

    return MaterialApp(
      theme: new ThemeData(platform: TargetPlatform.iOS),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: _pc,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Center(
                child: _getPageByIndex(index)
            );
          },
        ),
      ),
    );
  }
}
