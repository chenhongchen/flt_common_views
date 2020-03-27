import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flt_common_views/flt_common_views.dart';

void main() {
  const MethodChannel channel = MethodChannel('flt_common_views');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FltCommonViews.platformVersion, '42');
  });
}
