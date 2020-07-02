import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_note/page_files.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:money_note/main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

int nowAccount = 0;
List<String> account = ['錢包', '郵局', '一卡通', '悠遊卡'];

Future<File> getLocalFile(index) async {
  String dir;
  if(index == 0)
    dir = (await getApplicationDocumentsDirectory()).path;
  else
    dir = '/storage/emulated/0/Download';
  return new File('$dir/' + account[nowAccount] + '.txt');
}
Future<List> loadData(index) async {
  try {
    File file = await getLocalFile(index);
    List contents = await file.readAsLines();
    return contents;
  } on FileSystemException {
    return List();
  }
}
Future<String> loadDataString(index) async {
  try {
    File file = await getLocalFile(index);
    String contents = await file.readAsString();
    return contents;
  } on FileSystemException {
    return '';
  }
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin fln;

  List record = new List();
  List data = new List();
  List date = new List();
  List method = new List();
  List type = new List();
  List cost = new List();
  List remark = new List();

  int total = 0;
  bool dateFlag = false;

  static String getMoneyStyleStr(String text) {
    String temp = "";
    if (text.length <= 3) {
      temp = text;
      return temp;
    } else {
      int count = ((text.length) ~/ 3);
      int startIndex = text.length % 3;
      if (startIndex != 0) {
        if (count == 1) {
          temp = text.substring(0, startIndex) +
              "," +
              text.substring(startIndex, text.length);
        } else {
          temp = text.substring(0, startIndex) + ",";
          int syCount = count - 1;
          for (int i = 0; i < syCount; i++)
            temp +=
                text.substring(startIndex + 3 * i, startIndex + (i * 3) + 3) +
                    ",";
          temp +=
              text.substring((startIndex + (syCount - 1) * 3 + 3), text.length);
        }
      } else {
        for (int i = 0; i < count; i++) {
          if (i != count - 1)
            temp += text.substring(3 * i, (i + 1) * 3) + ",";
          else
            temp += text.substring(3 * i, (i + 1) * 3);
        }
      }
      return temp;
    }
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }
  showNotification() async {
    List<String> lines = List<String>();
    lines.add('\$ ' + getMoneyStyleStr(total.toString()));
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: account[nowAccount],
        summaryText: '餘額通知');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Low, priority: Priority.High, showWhen: false, ongoing: true, styleInformation: inboxStyleInformation);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await fln.show(
        0, '', '', platformChannelSpecifics,
        payload: '');
  }

  Future<Null> _uploadData(index) async {
    String str = '';
    data.removeAt(index);
    for (var s in data) str += s + "\n";
    await (await getLocalFile(0)).writeAsString(str);

    _checkData();
  }

  void _checkData() {
    loadData(0).then((List l) {
      setState(() {
        data = l;
        total = 0;
        date.clear();
        method.clear();
        type.clear();
        cost.clear();
        remark.clear();
        for(var i = 0; i < data.length; i++) {
          List buffer = data[i].split(',');
          List dateBuffer = buffer[0].split('/');
          String dateStr = dateBuffer[1] + ' 月 ' + dateBuffer[2] + ' 日';

          if(buffer[1] == '支出')
            total -= int.parse(buffer[3]);
          else
            total += int.parse(buffer[3]);

          if(date.indexOf(dateStr) == -1)
            date.add(dateStr);
          else
            date.add('');

          method.add(buffer[1]);
          type.add(buffer[2]);
          cost.add(getMoneyStyleStr(buffer[3]));
          remark.add(buffer[4]);
        }
        showNotification();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print("permission status is " + permission.toString());
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);

    fln = new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    fln.initialize(initSetttings, onSelectNotification: onSelectNotification);

    _checkData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '記帳',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              jumpPage(1);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF101010),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 50,
            ),
            children: <Widget> [
              ListTile(
                title: Text(
                  '檔案管理',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    letterSpacing: 1.0,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>FilesPage())).then((data) {_checkData();});
                },
              ),
              Divider(
                color: Color(0xAA545458),
              ),
              ListTile(
                title: Text(
                  '關於',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    letterSpacing: 1.0,
                  ),),
                onTap: () {
                  Fluttertoast.showToast(
                    msg: "製作名單\n\n 詹 詠 翔\n 葉 宇 翔\n 賴 民 修\n 賴 智 嘉",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 20.0
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 90,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: account.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      nowAccount = index;
                      _checkData();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Text(
                      account[index],
                      style: TextStyle(
                        color: index == nowAccount ? Colors.white : Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF101010),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'TWD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          '\$ ' + getMoneyStyleStr(total.toString()),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF202020),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              if(date[index] != '')
                                Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: Text(
                                        date[index],
                                        style: TextStyle(
                                          color: Color(0x99ebebf5),
                                          fontSize: 25,
                                          //fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                        ),
                                      )
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 25,
                                    right: 25,
                                    left: 25
                                ),
                                child: GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return SimpleDialog(
                                            title: Center(
                                              child: Text(
                                                "是否刪除資料",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                            titlePadding: EdgeInsets.only(
                                              top: 20,
                                              right: 25,
                                              left: 25,
                                            ),
                                            backgroundColor: Color(0x99505050),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            children: <Widget>[
                                              ListTile(
                                                title: Center(
                                                  child: Text(
                                                    "確定",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  _uploadData(index);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                title: Center(
                                                  child: Text(
                                                    "取消",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF101010),
                                      borderRadius: BorderRadius.circular((25)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            type[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          if (remark[index] != "")
                                            Text(
                                              remark[index],
                                              style: TextStyle(
                                                color: Color(0x99ebebf5),
                                                fontSize: 20.0,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  method[index],
                                                  style: TextStyle(
                                                    color: (method[index] == '支出') ? Color(0xfff23131) : Color(0xff36b330),
                                                    fontSize: 20.0,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  "\$ " + cost[index],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
