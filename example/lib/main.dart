import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flt_common_views/flt_common_views.dart';
import 'package:flt_common_views/views/alter.dart';
import 'package:flt_common_views/views/bottom_sheet/bottom_sheet_view.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FltCommonViews.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var _brightness = MediaQuery.of(context).platformBrightness;
    Color color = Colors.white;
    Color titleColor = Colors.black;
    if (_brightness == Brightness.dark) {
      color = Colors.black;
      titleColor = Colors.white;
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                showAlert(context,
                    // title: 'bbb',
                    msg: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                    leftTitle: '取消',
                    rightTitle: '确定');
              },
              child: Container(
                alignment: Alignment.center,
                height: 44,
                color: Colors.transparent,
                child: Text(
                  'showAlert',
                  style: TextStyle(color: titleColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                BottomSheetItem item = BottomSheetItem(text: 'aaa');
                BottomSheetItem item1 = BottomSheetItem(
                    text: '', height: MediaQuery.of(context).padding.bottom);
                showBottomSheetPage(
                  context: context,
                  sheetItems: [item, item1],
                );
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                height: 44,
                child: Text(
                  'showBottomSheetPage',
                  style: TextStyle(color: titleColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
