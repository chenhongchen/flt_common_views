import 'package:flt_common_views/views/bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef TapBottomSheetItemCallback = void Function(BottomSheetItem sheetItem);

Future<T?> showBottomSheetPage<T>({
  required BuildContext context,
  required List<BottomSheetItem> sheetItems,
  Color bgColor = Colors.black54,
  TapBottomSheetItemCallback? onTap,
}) {
  return customShowModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetView(sheetItems, onTap);
    },
    backgroundColor: bgColor,
    barrierColor: bgColor,
  );
}

class BottomSheetItem {
  String text;
  TextStyle? style;
  Color backColor;
  Color? dividerColor;
  double height;

  BottomSheetItem(
      {this.text = '',
      this.style,
      this.backColor = Colors.white,
      this.dividerColor,
      this.height = 58.0}) {
    if (style == null) {
      style = TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Color(0xFF444444),
        decoration: TextDecoration.none,
      );
    }
    if (dividerColor == null) {
      dividerColor = Color(0xFFEBEBEB);
    }
  }
}

class BottomSheetView extends StatelessWidget {
  List<BottomSheetItem> sheetItems;
  TapBottomSheetItemCallback? onTap;

  BottomSheetView(this.sheetItems, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _getTotalHeight(),
        child: Column(children: _builSheet(context)));
  }

  List<Widget> _builSheet(BuildContext context) {
    var sheetViews = <Widget>[];
    for (BottomSheetItem sheetItem in sheetItems) {
      var view = GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: sheetItem.height,
              color: sheetItem.backColor,
              child: Center(
                child: Text(
                  sheetItem.text,
                  style: sheetItem.style,
                ),
              ),
            ),
            Positioned(
                left: 20,
                right: 20,
                child: Container(
                  color: sheetItem.dividerColor,
                  height: 1.0 / MediaQuery.of(context).devicePixelRatio,
                )),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap!(sheetItem);
          }
        },
      );
      sheetViews.add(view);
    }
    return sheetViews;
  }

  double _getTotalHeight() {
    double totalHeight = 0.0;
    for (BottomSheetItem sheetItem in sheetItems) {
      totalHeight = totalHeight + sheetItem.height;
    }
    return totalHeight;
  }
}
