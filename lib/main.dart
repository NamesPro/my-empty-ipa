import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Void Injector',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: const InjectorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InjectorScreen extends StatefulWidget {
  const InjectorScreen({super.key});

  @override
  State<InjectorScreen> createState() => _InjectorScreenState();
}

class _InjectorScreenState extends State<InjectorScreen> {
  bool _isInjecting = false;
  double _progress = 0.0;
  bool _showScam = false;
  List<String> _logLines = [];
  Timer? _timer;

  final List<String> _logMessages = [
    '[System] Initializing injection engine...',
    '[Kernel] Bypassing PAC protection...',
    '[Memory] Allocating payload buffer...',
    '[Exploit] CVE-2026-20700 triggered',
    '[ROP] Building gadget chain...',
    '[JOP] Executing shellcode...',
    '[IO] Overwriting kernel memory...',
    '[SELinux] Disabling security hooks...',
    '[SELF] Unlocking restricted regions...',
    '[KERN] Injecting rootkit...',
    '[DONE] Injection complete. You got scammed.',
  ];

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _progress = 0.0;
      _showScam = false;
      _logLines = [];
    });

    int logIndex = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress = (_progress + 1.0) / 300 * 100;
        if (_progress > 100) _progress = 100;

        if (logIndex < _logMessages.length && _progress.toInt() % 20 == 0) {
          _logLines.add(_logMessages[logIndex]);
          logIndex++;
        }

        if (_progress >= 100) {
          timer.cancel();
          _showScam = true;
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _isInjecting = false;
              _progress = 0.0;
              _logLines = [];
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Void Injector',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 50),

                  if (!_isInjecting)
                    ElevatedButton(
                      onPressed: _startInjection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'INJECT CHEAT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),

                  if (_isInjecting) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      child: LinearProgressIndicator(
                        value: _progress / 100,
                        backgroundColor: Colors.grey[800],
                        color: Colors.white,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_progress.toInt()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _logLines.map((line) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                line,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),
                ],
              ),
            ),
          ),

          if (_showScam)
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Text(
                  'YOU GOT SCAMMED',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
