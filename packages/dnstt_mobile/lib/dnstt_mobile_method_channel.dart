import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dnstt_mobile_platform_interface.dart';
import 'dnstt_mobile_types.dart';

/// An implementation of [DnsttMobilePlatform] that uses method channels.
class MethodChannelDnsttMobile extends DnsttMobilePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dnstt_mobile');

  @override
  @override
  Future<bool> startTunnel(String domain, String pubkey, String resolver) async {
    final started = await methodChannel.invokeMethod<bool>(
      'startTunnel',
      {
        'domain': domain,
        'pubkey': pubkey,
        'resolver': resolver,
      },
    );
    return started ?? false;
  }

  @override
  Future<void> stopTunnel() async {
    await methodChannel.invokeMethod<void>('stopTunnel');
  }

  @override
  Future<DnsttMobileStatus> status() async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>('status');
    final runningValue = result?['running'];
    final lastErrorValue = result?['lastError'];
    return DnsttMobileStatus(
      running: runningValue is bool ? runningValue : false,
      lastError: lastErrorValue is String ? lastErrorValue : '',
    );
  }
}
