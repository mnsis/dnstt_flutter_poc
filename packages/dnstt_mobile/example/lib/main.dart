import 'package:flutter/material.dart';
import 'package:dnstt_mobile/dnstt_mobile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dnsttMobilePlugin = DnsttMobile();
  String _statusText = 'Unknown';

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final status = await _dnsttMobilePlugin.status();
    if (!mounted) {
      return;
    }
    setState(() {
      _statusText = status.running ? 'Connected' : 'Disconnected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Status: $_statusText\n'),
        ),
      ),
    );
  }
}
