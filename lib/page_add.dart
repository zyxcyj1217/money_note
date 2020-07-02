import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:money_note/page_home.dart';
import 'package:money_note/main.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  FocusNode focusNode2 = new FocusNode();
  DateTime now = new DateTime.now();

  int method = 0;

  List<String> inType = ['零用錢', '撿到錢', '領工錢', '其他',];
  List<String> outType = ['飲食', '日常', '交通', '娛樂', '其他',];
  List<String> inputData = ['支出', '飲食', '', ''];

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/' + account[nowAccount] + '.txt');
  }
  Future<String> _loadDataString() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return '';
    }
  }
  Future<Null> _uploadData() async {
    String str =
        now.year.toString() + '/' + now.month.toString() + '/' + now.day.toString() + ',' +
            inputData[0] + ',' + inputData[1] + ',' + inputData[2] + ',' + inputData[3];
    await (await _getLocalFile()).writeAsString('$str\n' + await _loadDataString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            jumpPage(0);
          },
        ),
        title: Text(
          '新增',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          jumpPage(0);
          return false;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Container(
                          height: 100,
                          child: CupertinoPicker(
                            backgroundColor: Colors.black,
                            itemExtent: 50,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                method = index;
                                if (index == 0)
                                  inputData[0] = "支出";
                                else
                                  inputData[0] = "收入";
                              });
                            },
                            children: <Widget>[
                              Center(child: Text("支出", style: TextStyle(fontSize: 30.0, color: Colors.white))),
                              Center(child: Text("收入", style: TextStyle(fontSize: 30.0, color: Colors.white))),
                            ],
                          ),
                        ),
                      ),
                      if (method == 0)
                        CupertinoPageScaffold(
                          navigationBar: CupertinoNavigationBar(
                            backgroundColor: Colors.black,
                          ),
                          child: Container(
                            height: 100,
                            child: CupertinoPicker(
                              backgroundColor: Colors.black,
                              itemExtent: 50,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  inputData[1] = outType[index];
                                });
                              },
                              children: <Widget>[
                                for (var i in outType)
                                  Center(
                                      child: Text(i, style: TextStyle(fontSize: 30.0, color: Colors.white))),
                              ],
                            ),
                          ),
                        )
                      else
                        CupertinoPageScaffold(
                          navigationBar: CupertinoNavigationBar(
                            backgroundColor: Colors.black,
                          ),
                          child: Container(
                            height: 100,
                            child: CupertinoPicker(
                              backgroundColor: Colors.black,
                              itemExtent: 50,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  inputData[1] = inType[index];
                                });
                              },
                              children: <Widget>[
                                for (var i in inType)
                                  Center(
                                      child: Text(i,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.white))),
                              ],
                            ),
                          ),
                        ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                inputData[2] = int.parse(text).toString();
                              });
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(focusNode2);
                            },
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.white,
                            style: TextStyle(fontSize: 30.0, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "金額",
                              hintStyle:
                              TextStyle(fontSize: 30.0, color: Colors.white60),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: TextField(
                            focusNode: focusNode2,
                            onChanged: (text) {
                              setState(() {
                                inputData[3] = text;
                              });
                            },
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.white,
                            style: TextStyle(fontSize: 30.0, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "備註",
                              hintStyle:
                              TextStyle(fontSize: 30.0, color: Colors.white60),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: FractionalOffset.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 50,
                    bottom: 50,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (inputData[2] != '') {
                          _uploadData();
                          jumpPage(0);
                        }
                      });
                    },
                    child: Text(
                      '確定',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: (inputData[2] == '') ? Colors.white60 : Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
