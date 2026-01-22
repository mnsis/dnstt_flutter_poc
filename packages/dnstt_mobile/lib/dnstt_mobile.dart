export 'dnstt_mobile_types.dart';

import 'dnstt_mobile_platform_interface.dart';
import 'dnstt_mobile_types.dart';

class DnsttMobile {
  Future<bool> startTunnel(String domain, String pubkey, String resolver) {
    return DnsttMobilePlatform.instance.startTunnel(domain, pubkey, resolver);
  }

  Future<void> stopTunnel() {
    return DnsttMobilePlatform.instance.stopTunnel();
  }

  Future<DnsttMobileStatus> status() {
    return DnsttMobilePlatform.instance.status();
  }
}
