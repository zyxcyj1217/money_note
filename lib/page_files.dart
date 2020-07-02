import 'package:flutter/material.dart';
import 'package:money_note/page_home.dart';
import 'package:money_note/main.dart';

class FilesPage extends StatefulWidget {
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  Future<Null> _exportData() async{
    await (await getLocalFile(1)).writeAsString(await loadDataString(0));
  }
  Future<Null> _importData() async{
    await (await getLocalFile(0)).writeAsString(await loadDataString(1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop("reload");
            },
          ),
          title: Text(
            '檔案',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SimpleDialog(
                            title: Center(
                              child: Text(
                                "是否匯出檔案",
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
                                  _exportData();
                                  Navigator.of(context).pop("reload");
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
                  child:Text(
                    '匯出檔案',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SimpleDialog(
                            title: Center(
                              child: Text(
                                "是否匯入檔案",
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
                                  _importData();
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
                  child:Text(
                    '匯入檔案',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      letterSpacing: 1.5,
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
