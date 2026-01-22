import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnstt_mobile/dnstt_mobile_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDnsttMobile platform = MethodChannelDnsttMobile();
  const MethodChannel channel = MethodChannel('dnstt_mobile');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'startTunnel':
            return true;
          case 'stopTunnel':
            return null;
          case 'status':
            return {'running': true, 'lastError': ''};
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('startTunnel', () async {
    expect(await platform.startTunnel('example.com', 'pub', 'https://1.1.1.1/dns-query'), isTrue);
  });

  test('status', () async {
    final status = await platform.status();
    expect(status.running, isTrue);
    expect(status.lastError, isEmpty);
  });
}
