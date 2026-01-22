import 'package:flutter/material.dart';
import 'package:dnstt_mobile/dnstt_mobile.dart';

void main() {
  runApp(const DnsttApp());
}

class DnsttApp extends StatelessWidget {
  const DnsttApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNSTT POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const DnsttHomePage(),
    );
  }
}

class DnsttHomePage extends StatefulWidget {
  const DnsttHomePage({super.key});

  @override
  State<DnsttHomePage> createState() => _DnsttHomePageState();
}

class _DnsttHomePageState extends State<DnsttHomePage> {
  final _domainController = TextEditingController();
  final _pubkeyController = TextEditingController();
  final _resolverController = TextEditingController(text: 'https://1.1.1.1/dns-query');
  final _dnstt = DnsttMobile();

  bool _running = false;
  String _lastError = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _pubkeyController.dispose();
    _resolverController.dispose();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    try {
      final status = await _dnstt.status();
      if (!mounted) {
        return;
      }
      setState(() {
        _running = status.running;
        _lastError = status.lastError;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _lastError = error.toString();
      });
    }
  }

  Future<void> _connect() async {
    setState(() {
      _busy = true;
    });
    try {
      await _dnstt.startTunnel(
        _domainController.text.trim(),
        _pubkeyController.text.trim(),
        _resolverController.text.trim(),
      );
    } finally {
      await _refreshStatus();
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _disconnect() async {
    setState(() {
      _busy = true;
    });
    try {
      await _dnstt.stopTunnel();
    } finally {
      await _refreshStatus();
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _running ? 'Connected' : 'Disconnected';
    return Scaffold(
      appBar: AppBar(
        title: const Text('DNSTT POC'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Status: $statusText',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_lastError.isNotEmpty)
            Text(
              'Last error: $_lastError',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 24),
          TextField(
            controller: _domainController,
            decoration: const InputDecoration(
              labelText: 'Domain',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pubkeyController,
            decoration: const InputDecoration(
              labelText: 'Public Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _resolverController,
            decoration: const InputDecoration(
              labelText: 'DNS Resolver',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _busy || _running ? null : _connect,
                  child: const Text('Connect'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy || !_running ? null : _disconnect,
                  child: const Text('Disconnect'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _busy ? null : _refreshStatus,
            child: const Text('Refresh Status'),
          ),
        ],
      ),
    );
  }
}
