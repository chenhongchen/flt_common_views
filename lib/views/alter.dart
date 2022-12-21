import 'package:flutter/material.dart';

void showAlert(
  BuildContext context, {
  String title = '提示',
  String msg = '',
  TextStyle? titleStyle,
  TextStyle? msgStyle,
  String leftTitle = '取消',
  String rightTitle = '确定',
  VoidCallback? leftOnTap,
  VoidCallback? rightOnTap,
  TextStyle? leftStyle,
  TextStyle? rightStyle,
  Color? lineColor,
  Color? bgColor,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Color textColor = Color(0xFF222222);
      Color lineDefCol = Color(0xFFb1b2b1);
      Color bgDefColor = Colors.white;
      var _brightness = MediaQuery.of(context).platformBrightness;
      if (_brightness == Brightness.dark) {
        textColor = Color(0xFF999999);
        lineDefCol = Color(0xFF303030);
        bgDefColor = Color(0xFF1A1A1A);
      }
      lineColor = lineColor ?? lineDefCol;
      bgColor = bgColor ?? bgDefColor;
      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: titleStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
          ),
          Container(
            height: 3,
          ),
          Text(
            msg,
            style: msgStyle ??
                TextStyle(
                  fontWeight: FontWeight.normal,
                  color: textColor,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
          ),
        ],
      );
      if (title.length <= 0) {
        content = Center(
          child: Text(
            msg,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: textColor,
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        );
      } else if (msg.length <= 0) {
        content = Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 18,
              decoration: TextDecoration.none,
            ),
          ),
        );
      }
      double lineW = 1.0 / (MediaQuery.of(context).devicePixelRatio);
      return Material(
        color: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(children: <Widget>[
              Container(
                width: 270,
                color: bgColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      color: bgColor,
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: content,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AlterButton(
                            leftTitle,
                            onTap: leftOnTap,
                            textStyle: leftStyle,
                          ),
                          AlterButton(
                            rightTitle,
                            onTap: rightOnTap,
                            textStyle: rightStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                height: lineW,
                bottom: 44,
                child: Container(
                  color: lineColor,
                ),
              ),
              Positioned(
                left: 270 * 0.5,
                width: lineW,
                height: 44,
                bottom: 0,
                child: Container(
                  color: lineColor,
                ),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class AlterButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  AlterButton(this.title, {this.onTap, this.textStyle});

  @override
  Widget build(BuildContext context) {
    TextStyle? _textStyle = textStyle;
    if (_textStyle == null) {
      _textStyle = TextStyle(
        fontWeight: FontWeight.normal,
        color: Color(0xFF3478f6),
        fontSize: 17,
        decoration: TextDecoration.none,
      );
    }
    Color color = Colors.white;
    var _brightness = MediaQuery.of(context).platformBrightness;
    if (_brightness == Brightness.dark) {
      color = Color(0xFF1A1A1A);
    }
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 44,
          color: color,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _textStyle,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap!();
          }
        },
      ),
    );
  }
}
