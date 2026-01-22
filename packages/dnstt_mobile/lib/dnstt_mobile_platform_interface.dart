import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dnstt_mobile_method_channel.dart';
import 'dnstt_mobile_types.dart';

abstract class DnsttMobilePlatform extends PlatformInterface {
  /// Constructs a DnsttMobilePlatform.
  DnsttMobilePlatform() : super(token: _token);

  static final Object _token = Object();

  static DnsttMobilePlatform _instance = MethodChannelDnsttMobile();

  /// The default instance of [DnsttMobilePlatform] to use.
  ///
  /// Defaults to [MethodChannelDnsttMobile].
  static DnsttMobilePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DnsttMobilePlatform] when
  /// they register themselves.
  static set instance(DnsttMobilePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> startTunnel(String domain, String pubkey, String resolver) {
    throw UnimplementedError('startTunnel() has not been implemented.');
  }

  Future<void> stopTunnel() {
    throw UnimplementedError('stopTunnel() has not been implemented.');
  }

  Future<DnsttMobileStatus> status() {
    throw UnimplementedError('status() has not been implemented.');
  }
}
