import 'package:flutter_test/flutter_test.dart';
import 'package:dnstt_mobile/dnstt_mobile.dart';
import 'package:dnstt_mobile/dnstt_mobile_platform_interface.dart';
import 'package:dnstt_mobile/dnstt_mobile_method_channel.dart';
import 'package:dnstt_mobile/dnstt_mobile_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDnsttMobilePlatform
    with MockPlatformInterfaceMixin
    implements DnsttMobilePlatform {

  @override
  Future<bool> startTunnel(String domain, String pubkey, String resolver) => Future.value(true);

  @override
  Future<void> stopTunnel() => Future.value();

  @override
  Future<DnsttMobileStatus> status() => Future.value(const DnsttMobileStatus(running: true, lastError: ''));
}

void main() {
  final DnsttMobilePlatform initialPlatform = DnsttMobilePlatform.instance;

  test('$MethodChannelDnsttMobile is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDnsttMobile>());
  });

  test('startTunnel', () async {
    DnsttMobile dnsttMobilePlugin = DnsttMobile();
    MockDnsttMobilePlatform fakePlatform = MockDnsttMobilePlatform();
    DnsttMobilePlatform.instance = fakePlatform;

    expect(await dnsttMobilePlugin.startTunnel('example.com', 'pub', 'https://1.1.1.1/dns-query'), isTrue);
  });
}
